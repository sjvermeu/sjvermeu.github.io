Title: Visualizing constraints
Date: 2014-05-31 03:47
Category: SELinux
Tags: constrain, constraints, dot, graphviz, seinfo, selinux
Slug: visualizing-constraints

SELinux constraints are an interesting way to implement specific, well,
constraints on what SELinux allows. Most SELinux rules that users come
in contact with are purely type oriented: allow something to do
something against something. In fact, most of the SELinux rules applied
on a system are such `allow` rules.

The restriction of such `allow` rules is that they only take into
consideration the *type* of the contexts that participate. This is the
[type
enforcement](https://wiki.gentoo.org/wiki/SELinux/Type_enforcement) part
of the SELinux mandatory access control system.

Constraints on the other hand work on the user, role and type part of a
context. Consider this piece of constraint code:

    constrain file all_file_perms (
      u1 == u2
      or u1 == system_u
      or u2 == system_u
      or t1 != ubac_constrained_type
      or t2 != ubac_constrained_type
    );

This particular constraint definition tells the SELinux subsystem that,
when an operation against a *file* class is performed (any operation, as
*all\_file\_perms* is used, but individual, specific permissions can be
listed as well), this is denied if none of the following conditions are
met:

-   The SELinux user of the subject and object are the same
-   The SELinux user of the subject or object is `system_u`
-   The SELinux type of the subject does not have the
    `ubac_constrained_type` attribute set
-   The SELinux type of the object does not have the
    `ubac_constrained_type` attribute set

If none of the conditions are met, then the action is denied, regardless
of the `allow` rules set otherwise. If at least one condition is met,
then the `allow` rules (and other SELinux rules) decide if an action can
be taken or not.

Constraints are currently difficult to query though. There is **seinfo
--constrain** which gives all constraints, using the Reverse Polish
Notation - not something easily readable by users:

    ~$ seinfo --constrain
    constrain { sem } { create destroy getattr setattr read write associate unix_read unix_write  } 
    (  u1 u2 ==  u1 system_u ==  ||  u2 system_u ==  ||  t1 { screen_var_run_t gnome_xdg_config_home_t admin_crontab_t 
    links_input_xevent_t gpg_pinentry_tmp_t virt_content_t print_spool_t crontab_tmp_t httpd_user_htaccess_t ssh_keysign_t 
    remote_input_xevent_t gnome_home_t mozilla_tmpfs_t staff_gkeyringd_t consolekit_input_xevent_t user_mail_tmp_t 
    chromium_xdg_config_t mozilla_input_xevent_t chromium_tmp_t httpd_user_script_exec_t gnome_keyring_tmp_t links_tmpfs_t 
    skype_tmp_t user_gkeyringd_t svirt_home_t sysadm_su_t virt_home_t skype_home_t wireshark_tmp_t xscreensaver_xproperty_t 
    consolekit_xproperty_t user_home_dir_t gpg_pinentry_xproperty_t mplayer_home_t mozilla_plugin_input_xevent_t mozilla_plugin_tmp_t 
    mozilla_xproperty_t xdm_input_xevent_t chromium_input_xevent_t java_tmpfs_t googletalk_plugin_xproperty_t sysadm_t gorg_t gpg_t 
    java_t links_t staff_dbusd_t httpd_user_ra_content_t httpd_user_rw_content_t googletalk_plugin_tmp_t gpg_agent_tmp_t 
    ssh_agent_tmp_t sysadm_ssh_agent_t user_fonts_cache_t user_tmp_t googletalk_plugin_input_xevent_t user_dbusd_t xserver_tmpfs_t 
    iceauth_home_t qemu_input_xevent_t xauth_home_t mutt_home_t sysadm_dbusd_t remote_xproperty_t gnome_xdg_config_t screen_home_t 
    chromium_xproperty_t chromium_tmpfs_t wireshark_tmpfs_t xdg_videos_home_t pulseaudio_input_xevent_t krb5_home_t 
    pulseaudio_xproperty_t xscreensaver_input_xevent_t gpg_pinentry_input_xevent_t httpd_user_script_t gnome_xdg_cache_home_t 
    mozilla_plugin_tmpfs_t user_home_t user_sudo_t ssh_input_xevent_t ssh_tmpfs_t xdg_music_home_t gconf_tmp_t flash_home_t 
    java_home_t skype_tmpfs_t xdg_pictures_home_t xdg_data_home_t gnome_keyring_home_t wireshark_home_t chromium_renderer_xproperty_t 
    gpg_pinentry_t mozilla_t session_dbusd_tmp_t staff_sudo_t xdg_config_home_t user_su_t pan_input_xevent_t user_devpts_t 
    mysqld_home_t pan_tmpfs_t root_input_xevent_t links_home_t sysadm_screen_t pulseaudio_tmpfs_t sysadm_gkeyringd_t mail_home_rw_t 
    gconf_home_t mozilla_plugin_xproperty_t mutt_tmp_t httpd_user_content_t mozilla_xdg_cache_t mozilla_home_t alsa_home_t 
    pulseaudio_t mencoder_t admin_crontab_tmp_t xdg_documents_home_t user_tty_device_t java_tmp_t gnome_xdg_data_home_t wireshark_t 
    mozilla_plugin_home_t googletalk_plugin_tmpfs_t user_cron_spool_t mplayer_input_xevent_t skype_input_xevent_t xxe_home_t 
    mozilla_tmp_t gconfd_t lpr_t mutt_t pan_t ssh_t staff_t user_t xauth_t skype_xproperty_t mozilla_plugin_config_t 
    links_xproperty_t mplayer_xproperty_t xdg_runtime_home_t cert_home_t mplayer_tmpfs_t user_fonts_t user_tmpfs_t mutt_conf_t 
    gpg_secret_t gpg_helper_t staff_ssh_agent_t pulseaudio_tmp_t xscreensaver_t googletalk_plugin_xdg_config_t staff_screen_t 
    user_fonts_config_t ssh_home_t staff_su_t screen_tmp_t mozilla_plugin_t user_input_xevent_t xserver_tmp_t wireshark_xproperty_t 
    user_mail_t pulseaudio_home_t xdg_cache_home_t user_ssh_agent_t xdg_downloads_home_t chromium_renderer_input_xevent_t cronjob_t 
    crontab_t pan_home_t session_dbusd_home_t gpg_agent_t xauth_tmp_t xscreensaver_tmpfs_t iceauth_t mplayer_t chromium_xdg_cache_t 
    lpr_tmp_t gpg_pinentry_tmpfs_t pan_xproperty_t ssh_xproperty_t xdm_xproperty_t java_xproperty_t sysadm_sudo_t qemu_xproperty_t 
    root_xproperty_t user_xproperty_t mail_home_t xserver_t java_input_xevent_t user_screen_t wireshark_input_xevent_t } !=  ||  t2 { 
    screen_var_run_t gnome_xdg_config_home_t admin_crontab_t links_input_xevent_t gpg_pinentry_tmp_t virt_content_t print_spool_t 
    crontab_tmp_t httpd_user_htaccess_t ssh_keysign_t remote_input_xevent_t gnome_home_t mozilla_tmpfs_t staff_gkeyringd_t 
    consolekit_input_xevent_t user_mail_tmp_t chromium_xdg_config_t mozilla_input_xevent_t chromium_tmp_t httpd_user_script_exec_t 
    gnome_keyring_tmp_t links_tmpfs_t skype_tmp_t user_gkeyringd_t svirt_home_t sysadm_su_t virt_home_t skype_home_t wireshark_tmp_t 
    xscreensaver_xproperty_t consolekit_xproperty_t user_home_dir_t gpg_pinentry_xproperty_t mplayer_home_t 
    mozilla_plugin_input_xevent_t mozilla_plugin_tmp_t mozilla_xproperty_t xdm_input_xevent_t chromium_input_xevent_t java_tmpfs_t 
    googletalk_plugin_xproperty_t sysadm_t gorg_t gpg_t java_t links_t staff_dbusd_t httpd_user_ra_content_t httpd_user_rw_content_t 
    googletalk_plugin_tmp_t gpg_agent_tmp_t ssh_agent_tmp_t sysadm_ssh_agent_t user_fonts_cache_t user_tmp_t 
    googletalk_plugin_input_xevent_t user_dbusd_t xserver_tmpfs_t iceauth_home_t qemu_input_xevent_t xauth_home_t mutt_home_t 
    sysadm_dbusd_t remote_xproperty_t gnome_xdg_config_t screen_home_t chromium_xproperty_t chromium_tmpfs_t wireshark_tmpfs_t 
    xdg_videos_home_t pulseaudio_input_xevent_t krb5_home_t pulseaudio_xproperty_t xscreensaver_input_xevent_t 
    gpg_pinentry_input_xevent_t httpd_user_script_t gnome_xdg_cache_home_t mozilla_plugin_tmpfs_t user_home_t user_sudo_t 
    ssh_input_xevent_t ssh_tmpfs_t xdg_music_home_t gconf_tmp_t flash_home_t java_home_t skype_tmpfs_t xdg_pictures_home_t 
    xdg_data_home_t gnome_keyring_home_t wireshark_home_t chromium_renderer_xproperty_t gpg_pinentry_t mozilla_t session_dbusd_tmp_t 
    staff_sudo_t xdg_config_home_t user_su_t pan_input_xevent_t user_devpts_t mysqld_home_t pan_tmpfs_t root_input_xevent_t 
    links_home_t sysadm_screen_t pulseaudio_tmpfs_t sysadm_gkeyringd_t mail_home_rw_t gconf_home_t mozilla_plugin_xproperty_t 
    mutt_tmp_t httpd_user_content_t mozilla_xdg_cache_t mozilla_home_t alsa_home_t pulseaudio_t mencoder_t admin_crontab_tmp_t 
    xdg_documents_home_t user_tty_device_t java_tmp_t gnome_xdg_data_home_t wireshark_t mozilla_plugin_home_t 
    googletalk_plugin_tmpfs_t user_cron_spool_t mplayer_input_xevent_t skype_input_xevent_t xxe_home_t mozilla_tmp_t gconfd_t lpr_t 
    mutt_t pan_t ssh_t staff_t user_t xauth_t skype_xproperty_t mozilla_plugin_config_t links_xproperty_t mplayer_xproperty_t 
    xdg_runtime_home_t cert_home_t mplayer_tmpfs_t user_fonts_t user_tmpfs_t mutt_conf_t gpg_secret_t gpg_helper_t staff_ssh_agent_t 
    pulseaudio_tmp_t xscreensaver_t googletalk_plugin_xdg_config_t staff_screen_t user_fonts_config_t ssh_home_t staff_su_t 
    screen_tmp_t mozilla_plugin_t user_input_xevent_t xserver_tmp_t wireshark_xproperty_t user_mail_t pulseaudio_home_t 
    xdg_cache_home_t user_ssh_agent_t xdg_downloads_home_t chromium_renderer_input_xevent_t cronjob_t crontab_t pan_home_t 
    session_dbusd_home_t gpg_agent_t xauth_tmp_t xscreensaver_tmpfs_t iceauth_t mplayer_t chromium_xdg_cache_t lpr_tmp_t 
    gpg_pinentry_tmpfs_t pan_xproperty_t ssh_xproperty_t xdm_xproperty_t java_xproperty_t sysadm_sudo_t qemu_xproperty_t 
    root_xproperty_t user_xproperty_t mail_home_t xserver_t java_input_xevent_t user_screen_t wireshark_input_xevent_t } !=  ||  t1 
     ==  || );

There RPN notation however isn't the only reason why constraints are
difficult to read. The other reason is that **seinfo** does not know
(anymore) about the attributes used to generate the constraints. As a
result, we get a huge list of all possible types that match a common
attribute - but we don't know which anymore.

Not everyone can read the source files in which the constraints are
defined, so I hacked together a script that generates
[GraphViz](http://graphviz.org/) dot file based on the **seinfo
--constrain** output for a given *class* and *permission* and,
optionally, limiting the huge list of types to a set that the user (err,
that is me ;-) is interested in.

For instance, to generate a graph of the constraints related to file
reads, limited to the `user_t` and `staff_t` types if huge lists would
otherwise be shown:

    ~$ seshowconstraint file read "user_t staff_t" > constraint-file.dot
    ~$ dot -Tsvg -O constraint-file.dot

This generates the following graph:

!SELinux constraint flow[](http://dev.gentoo.org/~swift/blog/201405/constraint-flow.svg)

If you're interested in the (ugly) script that does this, you can find
it on my
[github](https://github.com/sjvermeu/small.coding/blob/master/se_scripts/seshowconstraint)
location.

There are some patches laying around to support naming constraints and
taking the name up in the policy, so that denials based on constraints
can at least give feedback to the user which constraint is holding an
access back (rather than just a denial that the user doesn't know why).
Hopefully such patches can be made available in the kernel and user
space utilities soon.
