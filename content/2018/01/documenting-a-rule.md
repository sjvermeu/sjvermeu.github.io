Title: Documenting a rule
Date: 2018-01-24 20:40
Category: Security
Tags: xccdf,scap,baseline
Slug: documenting-a-rule

In the [first post][first] I talked about why configuration documentation is important. In the [second post][second] I looked into a good structure for configuration documentation of a technological service, and ended with an XCCDF template in which this documentation can be structured.
 
[first]: {filename}/2018/01/documenting-configuration-changes.md
[second]: {filename}/2018/01/structuring-a-configuration-baseline.md
 
The next step is to document the rules themselves, i.e. the actual content of a configuration baseline.
 
<!-- PELICAN_END_SUMMARY -->

**Fine-grained rules**
 
While from a high-level point of view, configuration items could be documented in a coarse-grained manner, a proper configuration baseline documents rules very fine-grained. Let's first consider a bad example:
 
> All application code files are root-owned, with read-write privileges for owner and group, and executable where it makes sense.
 
While such a rule could be interpreted correctly, it also leaves room for misinterpretation and ambiguity. Furthermore, it is not explicit. What are application code files? Where are they stored? What about group ownership? The executable permission, when does that make sense? Does the rule also imply that there is no privilege for world-wide access, or does it just ignore that?
 
A better example (or set of examples) would be:
 
- `/opt/postgresql` is recursively user-owned by root
- `/opt/postgresql` is recursively group-owned by root
- No files under `/opt/postgresql` are executable except when specified further
- All files in `/opt/postgresql/bin` are executable
- `/opt/postgresql` has `system_u:object_r:usr_t:s0` as SELinux context
- `/opt/postgresql/bin/postgres` has `system_u:object_r:postgresql_exec_t:s0` as SELinux context
 
And even that list is still not complete, but you get the gist. The focus here is to have fine-grained rules which are explicit and not ambiguous.
 
Of course, the above configuration rule is still a "simple" permission set. Configuration baselines go further than that of course. They can act on file content ("no PAM configuration files can refer to pam_rootok.so except for runuser and su"), run-time processes ("The processes with /usr/sbin/sshd as command and with -D as option must run within the sshd_t SELinux domain"), database query results, etc.
 
This granularity is especially useful later on when you want to automate compliance checks, because the more fine-grained a description is, the easier it is to develop and maintain checks on it. But before we look into remediation, let's document the rule a bit further.
 
**Metadata on the rules**
 
Let's consider the following configuration rule:
 
> `/opt/postgresql/bin/postgres` has `system_u:object_r:postgresql_exec_t:s0` as SELinux context
 
In the configuration baseline, we don't just want to state that this is the rule, and be finished. We need to describe the rule in more detail, as was described in the [previous post][second]. More specifically, we definitely want to
- know the rule's severity is, or how "bad" it would be if we detect a deviation from the rule
- have an indication if the rule is security-sensitive or more oriented to manageability
- a more elaborate description of the rule than just the title
- an indication why this rule is in place (what does it solve, fix or simplify)
- information on how to remediate if a deviation is found
- know if the rule is applicable to our environment or not
 
The severity in the *Security Content Automation Protocol (SCAP)* standard, which defines the XCCDF standard as well as OVAL and a few others like CVSS, uses the following possible values for severity: unknown, info, low, medium, high.
 
To indicate if a rule is security-oriented or not, XCCDF's role attribute is best used. With the role attribute, you state if a rule is to be included in the final scoring (a weighted value given to the compliance of a system) or not. If it is, then it is security sensitive.
 
The indication of a rule applicability in the environment might seem strange. If you document the configuration baseline, shouldn't it include only those settings you want? Well, yes and no. Personally, I like to include recommendations that we *do not follow* in the baseline as well.
 
Suppose for instance that an audit comes along and says you need to enable data encryption on the database. Let's put aside that an auditor should focus mainly/solely on the risks, and let the solutions be managed by the team (but be involved in accepting solutions of course), the team might do an assessment and find that data encryption on the database level (i.e. the database files are encrypted so non-DBA users with operating system interactive rights cannot read the data) is actually not going to remediate any risk, yet introduce more complexity.
 
In that situation, and assuming that the auditor agrees with a different control, you might want to add a rule to the configuration baseline about this. Either you document the wanted state (database files do not need to be encrypted), or you document the suggestion (database files should be encrypted) but explicitly state that you do not require or implement it, and document the reasoning for it. The rule is then augmented with references to the audit recommendation for historical reasons and to facilitate future discussions.
 
And yes, I know the rule "database files should be encrypted" is still ambiguous. The actual rule should be more specific to the technology).
 
**Documenting a rule in XCCDF**
 
In XCCDF, a rule is defined through the `Rule` XML entity, and is placed within a `Group`. The Group entities are used to structure the document, while the `Rule` entities document specific configuration directives.
 
The postgres related rule of above could be written as follows:
 
```
<Rule id="xccdf_com.example_rule_pgsql-selinux-context"
      role="full"
      selected="1"
      weight="5.1"
      severity="high"
      cluster-id="network">
  <title>
    /opt/postgresql/bin/postgres has system_u:object_r:postgresql_exec_t:s0 as SELinux context
  </title>
  <description>
    <xhtml:p>
      The postgres binary is the main binary of the PostgreSQL database daemon. Once started, it launches the necessary workers. To ensure that PostgreSQL runs in the proper SELinux domain (postgresql_t) its binary must be labeled with postgresql_exec_t.
    </xhtml:p>
    <xhtml:p>
      The current state of the label can be obtained using stat, or even more simple, the -Z option to ls:
    </xhtml:p>
    <xhtml:pre>~$ ls -Z /opt/postgresql/bin/postgres
-rwxr-xr-x. root root system_u:object_r:postgresql_exec_t:s0 /opt/postgresql/bin/postgres
    </xhtml:pre>
  </description>
  <rationale>
    <xhtml:p>
      The domain in which a process runs defines the SELinux controls that are active on the process. Services such as PostgreSQL have an established policy set that controls what a database service can and cannot do on the system.
    </xhtml:p>
    <xhtml:p>
      If the PostgreSQL daemon does not run in the postgresql_t domain, then SELinux might either block regular activities of the database (service availability impact), block behavior that impacts its effectiveness (integrity issue) or allow behavior that shouldn't be allowed. The latter can have significant consequences once a vulnerability is exploited.
    </xhtml:p>
  </rationale>
  <fixtext>
    Restore the context of the file using restorecon or chcon.
  </fixtext>
  <fix strategy="restrict" system="urn:xccdf:fix:script:sh">restorecon /opt/postgresql/bin/postgres
  </fix>
  <ident system="http://example.com/configbaseline">pgsql-01032</ident>
</Rule>
```
 
Although this is lots of XML, it is easy to see what each element declares. The [NIST IR 7275 document][nistir-7275] is a very good resource to continuously consult in order to find the right elements and their interpretation.
 
[nistir-7275]: https://csrc.nist.gov/CSRC/media/Publications/nistir/7275/rev-4/final/documents/nistir-7275r4_updated-march-2012_clean.pdf
 
There is one element added that is "specific" to the content of this blog post series and not the XCCDF standard, namely the identification. As mentioned in an earlier post, organizations might have their own taxonomy for technical service identification, and requirements on how to number or identify rules. In the above example, the rule is identified as `pgsql-01032`.
 
There is another attribute in use above that might need more clarification: the weight of the rule.
 
**Abusing CVSS for configuration weight scoring**
 
In the above example, a weight is given to the rule scoring (weight of 5.1). This number is obtained through a [CVSS calculator][cvsscalc], which is generally used to identify the risk of a security issue or vulnerability. CVSS stands for *Common Vulnerability Scoring System* and is a popular way to weight security risks (which are then associated with vulnerability reports, *Common Vulnerabilities and Exposures (CVE)*).
 
[cvsscalc]: https://www.first.org/cvss/calculator/3.0#CVSS:3.0/AV:N/AC:H/PR:N/UI:N/S:C/C:L/I:L/A:N/E:U/RL:O/CR:H/IR:H/AR:H/MAV:N/MAC:H/MPR:N/MUI:N/MS:U/MC:L/MI:N/MA:L
 
Misconfigurations can also be slightly interpreted as a security risk, although it requires some mental bridges. Rather than scoring the rule, you score the risk that it mitigates, and consider the worst thing that could happen if that rule is not implemented correctly. Now, worst-case thinking is subjective, so there will always be discussion on the weight of a rule. It is therefore important to have a consensus in the team (if the configuration baseline is team-owned) if this weight is actively used. Of course, an organization might choose to ignore the weight, or use a different scoring mechanism.
 
In the above situation, I scored what would happen if a vulnerability in PostgreSQL was successfully exploited, and SELinux couldn't mitigate the risk as the label of the file was wrong. The result of a wrong label *could be* that the PostgreSQL service runs in a higher privileged domain, or even in an unconfined domain (no SELinux restrictions active), so there is a heightened risk of confidentiality loss (beyond the database) and even integrity risk.
 
However, the confidentiality risk is scored as low, and integrity even in between (base risk is low, but due to other constraints put in place integrity impact is reduced further) because PostgreSQL runs as a non-administrative user on the system, and perhaps because the organization uses dedicated systems for database hosting (so other services are not easily impacted).
 
As mentioned, this is somewhat abusing the CVSS methodology, but is imo much more effective than trying to figure out your own scoring methodology. With CVSS, you start with scoring the risk regardless of context (CVSS Base), then adjust based on recent state or knowledge (CVSS Temporal), and finally adjust further with knowledge of the other settings or mitigating controls in place (CVSS Environmental).
 
Personally, I prefer to only use the CVSS Base scoring for configuration baselines, because the other two are highly depending on time (which is, for documentation, challenging) and the other controls (which is more of a concern for service technical documentation). So in my preferred situation, the rule would be scored as 5.4 rather than 5.1. But that's just me.
 
**Isn't this CCE?**
 
People who use SCAP a bit more might already be thinking if I'm not reinventing the wheel here. After all, SCAP also has a standard called *Common Configuration Enumeration (CCE)* which seems to be exactly what I'm doing here: enumerating the configuration of a technical service. And indeed, if you look at the [CCE list][ccelist] you'll find a number of Excel sheets (sigh) that define common configurations.
 
[ccelist]: https://nvd.nist.gov/config/cce/index
 
For instance, for Red Hat Enterprise Linux v5, there is an enumeration identified as CCE-4361-2, which states:
 
> File permissions for /etc/pki/tls/ldap should be set correctly
 
The CCE description then goes on stating that this is a permission setting (CCE Parameter), which can be rectified with `chmod` (CCE Technical Mechanism), and refers to a source for the setting.
 
However, CCE has a number of downsides.
 
First of all, it isn't being maintained anymore. And although XCCDF itself is also a quite old standard, it is still being looked into (a draft new version is being prepared) and is actively used as a standard. Red Hat is investing time and resources into secure configurations and compliancy aligned with SCAP, and other vendors publish SCAP-specific resources as well. CCE however would be a list, and thus requires continuous management. That RHELv5 is the most recent RHEL CCE list is a bad thing.
 
Second, CCE's structure is for me insufficient to use in configuration baselines. XCCDF has a much more mature and elaborate set of settings for this. What CCE does is actually what I use in the above example as the organization-specific identifier.
 
Finally, there aren't many tools that actively use CCE, unlike CVSS, XCCDF, OVAL, CVSS and other standards under the SCAP umbrella, which are all still actively used and developed upon by tools such as Open-SCAP.
 
**Profiling**
 
Before finishing this post, I want to talk about profiling.
 
Within an XCCDF benchmark, several profiles can be defined. In the XCCDF template I defined a single profile that covers all rules, but this can be fine-tuned to the needs of the organization. In XCCDF profiles, you can select individual rules (which ones are active for a profile and which ones aren't) and even fine-tune values for rules. This is called tailoring in XCCDF.
 
A first use case for profiles is to group different rules based on the selected setup. In case of Nginx for instance, one can consider Nginx being used as either a reverse proxy, a static website hosting or a dynamic web application hosting. In all three cases, some rules will be the same, but several rules will be different. Within XCCDF, you can document all rules, and then use profiles to group the rules related to a particular service use.
 
XCCDF allows for profile inheritance. This means that you can define a base Profile (all the rules that need to be applied, regardless of the service use) and then extend the profiles with individual rule selections.
 
With profiles, you can also fine-tune values. For instance, you could have a password policy in place that states that passwords on internal machines have to be at least 10 characters long, but on DMZ systems they need to be at least 15 characters long. Instead of defining two rules, the rule could refer to a particular variable (Value in XCCDF) which is then selected based on the Profile. The value for a password length is then by default 10, but the Profile for DMZ systems selects the other value (15).
 
Now, value-based tailoring is imo already a more advanced use of XCCDF, and is best looked into when you also start using OVAL or other automated checks. The tailoring information is then passed on to the automated compliance check so that the right value is validated.
 
Value-based tailoring also makes rules either more complex to write, or ambiguous to interpret without full profile awareness. Considering the password length requirement, the rule could become:
 
> The /etc/pam.d/password-auth file must refer to pam_passwdqc.so for the password service with a minimal password length of 10 (default) or 15 (DMZ) for the N4 password category
 
At least the rule is specific. Another approach would be to document it as follows:
 
> The /etc/pam.d/password-auth file must refer to pam_passwdqc.so with the proper organizational password controls
 
The documentation of the rule might document the proper controls further, but the rule is much less specific. Later checks might report that a system fails this check, referring to the title, which is insufficient for engineers or administrators to resolve.
 
**Generating the guide**
 
To close off this post, let's finish with how to generate the guide based on an XCCDF document. Personally, I use two approaches for this.
 
The first one is to rely on Open-SCAP. With Open-SCAP, you can generate guides easily:
 
```
~$ oscap xccdf generate guide xccdf.xml > ConfigBaseline.html
```
 
The second one, which I use more often, is a custom XSL style sheet, which also introduces the knowledge and interpretations of what this blog post series brings up (including the organizational identification). The end result is similar (the same content) but uses a structure/organization that is more in line with expectations.
 
For instance, in my company, the information security officers want to have a tabular overview of all the rules in a configuration baseline. So the XSL style sheet generates such a tabular overview, and uses in-documenting linking to the more elaborate descriptions of all the rules.
 
An [older version][xsl] is online for those interested. It uses JavaScript as well (in case you are security sensitive you might want to look into it) to allow collapsing rule documentation for faster online viewing.
 
[xsl]: {static}/static/2018/xccdf.xsl
 
The custom XSL has an additional advantage, namely that there is no dependency on Open-SCAP to generate the guides (even though it is perfectly possible to copy the XSL and continue). I can successfully generate the guide using [Microsoft's msxml][msxml] utility, using xsltproc, etc depending on the platform I'm on.
 
[msxml]: https://www.microsoft.com/en-us/download/details.aspx?id=21714

