Title: PostgreSQL with central authentication and authorization
Date: 2015-05-25 12:07
Category: Free Software
Tags: postgresql
Slug: postgresql-with-central-authentication-and-authorization

I have been running a PostgreSQL cluster for a while as the primary
backend for many services. The database system is very robust, well
supported by the community and very powerful. In this post, I'm going to
show how I use central authentication and authorization with PostgreSQL.

<!-- PELICAN_END_SUMMARY -->

Centralized management is an important principle whenever deployments
become very dispersed. For authentication and authorization, having a
high-available LDAP is one of the more powerful components in any
architecture. It isn't the only method though - it is also possible to
use a distributed approach where the master data is centrally managed,
but the proper data is distributed to the various systems that need it.
Such a distributed approach allows for high availability without the
need for a highly available central infrastructure (user ids, group
membership and passwords are distributed to the servers rather than
queried centrally). Here, I'm going to focus on a mixture of both
methods: central authentication for password verification, and
distributed authorization.

**PostgreSQL default uses in-database credentials**

By default, PostgreSQL uses in-database credentials for the
authentication and authorization. When a `CREATE ROLE` (or
`CREATE USER`) command is issued with a password, it is stored in the
`pg_catalog.pg_authid` table:

    postgres# select rolname, rolpassword from pg_catalog.pg_authid;
        rolname     |             rolpassword             
    ----------------+-------------------------------------
     postgres_admin | 
     dmvsl          | 
     johan          | 
     hdc_owner      | 
     hdc_reader     | 
     hdc_readwrite  | 
     hadoop         | 
     swift          | 
     sean           | 
     hdpreport      | 
     postgres       | md5c127bc9fc185daf0e06e785876e38484

this cannot be moved outside):

    postgres# \l db_hadoop
                                       List of databases
       Name    |   Owner   | Encoding |  Collate   |   Ctype    |     Access privileges     
    -----------+-----------+----------+------------+------------+---------------------------
     db_hadoop | hdc_owner | UTF8     | en_US.utf8 | en_US.utf8 | hdc_owner=CTc/hdc_owner  +
               |           |          |            |            | hdc_reader=c/hdc_owner   +
               |           |          |            |            | hdc_readwrite=c/hdc_owner

Furthermore, PostgreSQL has some additional access controls through its
`pg_hba.conf` file, in which the access towards the PostgreSQL service
itself can be governed based on context information (such as originating
IP address, target database, etc.).

For more information about the standard setups for PostgreSQL,
*definitely* go through the [official PostgreSQL
documentation](http://www.postgresql.org/docs/9.4/static/index.html) as
it is well documented and kept up-to-date.

Now, for central management, in-database settings become more difficult
to handle.

**Using PAM for authentication**

The first step to move the management of authentication and
authorization outside the database is to look at a way to authenticate
users (password verification) outside the database. I tend not to use a
distributed password approach (where a central component is responsible
for changing passwords on multiple targets), instead relying on a
high-available LDAP setup, but with local caching (to catch short-lived
network hick-ups) and local password use for last-hope accounts (such as
root and admin accounts).

PostgreSQL can be configured to directly interact with an LDAP, but I
like to use [Linux PAM](http://www.linux-pam.org/) whenever I can. For
my systems, it is a standard way of managing the authentication of many
services, so the same goes for PostgreSQL. And with the
[sys-auth/pam\_ldap](https://packages.gentoo.org/package/sys-auth/pam_ldap)
package integrating multiple services with LDAP is a breeze. So the
first step is to have PostgreSQL use PAM for authentication. This is
handled through its `pg_hba.conf` file:

    # TYPE  DATABASE        USER    ADDRESS         METHOD          [OPTIONS]
    local   all             all                     md5
    host    all             all     all             pam             pamservice=postgresql

This will have PostgreSQL use the `postgresql` PAM service for
authentication. The PAM configuration is thus in
`/etc/pam.d/postgresql`. In it, we can either directly use the LDAP PAM
modules, or use the SSSD modules and have SSSD work with LDAP.

Yet, this isn't sufficient. We still need to tell PostgreSQL which users
can be authenticated - the users need to be defined in the database
(just without password credentials because that is handled externally
now). This is done together with the authorization handling.

**Users and group membership**

Every service on the systems I maintain has dedicated groups in which
for instance its administrators are listed. For instance, for the
PostgreSQL services:

    # getent group gpgsqladmin
    gpgsqladmin:x:413843:swift,dmvsl

A local batch job (ran through cron) queries this group (which I call
the *masterlist*, as well as queries which users in PostgreSQL are
assigned the `postgres_admin` role (which is a superuser role like
postgres and is used as the intermediate role to assign to
administrators of a PostgreSQL service), known as the *slavelist*.
Delta's are then used to add the user or remove it.

    # Note: membersToAdd / membersToRemove / _psql are custom functions
    #       so do not vainly search for them on your system ;-)
    for member in $(membersToAdd ${masterlist} ${slavelist}) ; do
      _psql "CREATE USER ${member} LOGIN INHERIT;" postgres
      _psql "GRANT postgres_admin TO ${member};" postgres
    done

    for member in $(membersToRemove ${masterlist} ${slavelist}) ; do
      _psql "REVOKE postgres_admin FROM ${member};" postgres
      _psql "DROP USER ${member};" postgres
    done

The `postgres_admin` role is created whenever I create a PostgreSQL
instance. Likewise, for databases, a number of roles are added as well.
For instance, for the `db_hadoop` database, the `hdc_owner`,
`hdc_reader` and `hdc_readwrite` roles are created with the right set of
privileges. Users are then granted this role if they belong to the right
group in the LDAP. For instance:

    # getent group gpgsqlhdc_own
    gpgsqlhdc_own:x:413850:hadoop,johan,christov,sean

With this simple approach, granting users access to a database is a
matter of adding the user to the right group (like `gpgsqlhdc_ro` for
read-only access to the Hadoop related database(s)) and either wait for
the cron-job to add it, or manually run the authorization
synchronization. By standardizing on infrastructural roles (admin,
auditor) and data roles (owner, rw, ro) managing multiple databases is a
breeze.
