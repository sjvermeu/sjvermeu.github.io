Title: Automating compliance checks
Date: 2018-03-03 13:20
Category: Security
Tags: xccdf,oval,scap,baseline
Slug: automating-compliance-checks

With the configuration baseline for a technical service being described fully (see the [first][first], [second][second] and [third][third] post in this series), it is time to consider the validation of the settings in an automated manner. The preferred method for this is to use *Open Vulnerability and Assessment Language (OVAL)*, which is nowadays managed by the [Center for Internet Security][oval], abbreviated as CISecurity. Previously, OVAL was maintained and managed by Mitre under NIST supervision, and Google searches will often still point to the old sites. However, documentation is now maintained on CISecurity's [github repositories][github].

[first]: {filename}/2018/01/documenting-configuration-changes.md
[second]: {filename}/2018/01/structuring-a-configuration-baseline.md
[third]: {filename}/2018/01/documenting-a-rule.md
[oval]: https://oval.cisecurity.org/
[github]: https://github.com/OVALProject/Language/tree/5.11.2/docs
 
But I digress...
 
<!-- PELICAN_END_SUMMARY -->

**Read-only compliance validation**
 
One of the main ideas with OVAL is to have a language (XML-based) that represents state information (what something should be) which can be verified in a read-only fashion. Even more, from an operational perspective, it is very important that compliance checks *do not alter* anything, but only report.
 
Within its design, OVAL engineering has considered how to properly manage huge sets of assessment rules, and how to document this in an unambiguous manner. In the previous blog posts, ambiguity was resolved through writing style, and not much through actual, enforced definitions.
 
OVAL enforces this. You can't write a generic or ambiguous rule in OVAL. It is very specific, but that also means that it is daunting to implement the first few times. I've written many OVAL sets, and I still struggle with it (although that's because I don't do it enough in a short time-frame, and need to reread my own documentation regularly).
 
The capability to perform read-only validation with OVAL leads to a number of possible use cases. In the [5.10 specification][510spec] a number of use cases are provided. Basically, it boils down to vulnerability discovery (is a system vulnerable or not), patch management (is the system patched accordingly or not), configuration management (are the settings according to the rules or not), inventory management (detect what is installed on the system or what the systems' assets are), malware and threat indicator (detect if a system has been compromised or particular malware is active), policy enforcement (verify if a client system adheres to particular rules before it is granted access to a network), change tracking (regularly validating the state of a system and keeping track of changes), and security information management (centralizing results of an entire organization or environment and doing standard analytics on it).
 
[510spec]: http://oval.mitre.org/language/version5.10/OVAL_Language_Specification_09-14-2011.pdf
 
In this blog post series, I'm focusing on configuration management.
 
**OVAL structure**
 
Although the OVAL standard (just like the XCCDF standard actually) entails a number of major components, I'm going to focus on the OVAL definitions. Be aware though that the results of an OVAL scan are also standardized format, as are results of XCCDF scans for instance.
 
OVAL definitions have 4 to 5 blocks in them:
- the **definition** itself, which describes what is being validated and how. It refers to one or more tests that are to be executed or validated for the definition result to be calculated
- the **test** or tests, which are referred to by the definition. In each test, there is at least a reference to an object (what is being tested) and optionally to a state (what should the object look like)
- the **object**, which is a unique representation of a resource or resources on the system (a file, a process, a mount point, a kernel parameter, etc.). Object definitions can refer to multiple resources, depending on the definition.
- the **state**, which is a sort-of value mapping or validation that needs to be applied to an object to see if it is configured correctly
- the **variable**, an optional definition which is what it sounds like, a variable that substitutes an abstract definition with an actual definition,  allowing to write more reusable tests.
 
Let's get an example going, but without the XML structure, so in human language. We want to define that the Kerberos definition on a Linux system should allow forwardable tickets by default. This is accomplished by ensuring that, inside the `/etc/krb5.conf` file (which is an INI-style configuration file), the value of the `forwardable` key inside the `[libdefaults]` section is set to `true`.
 
In OVAL, the definition itself will document the above in human readable text, assign it a unique ID (like `oval:com.example.oval:def:1`) and mark it as being a definition for configuration validation (`compliance`). Then, it defines the criteria that need to be checked in order to properly validate if the rule is applicable or not. These criteria include validation if the OVAL statement is actually being run on a Linux system (as it makes no sense to run it against a Cisco router) which is Kerberos enabled, and then the criteria of the file check itself. Each criteria links to a test.
 
The test of the file itself links to an object and a state. There are a number of ways how we can check for this specific case. One is that the object is the `forwardable` key in the `[libdefaults]` section of the `/etc/krb5.conf` file, and the state is the value `true`. In this case, the state will point to those two entries (through their unique IDs) and define that the object must exist, and all matches must have a matching state. The "all matches" here is not that important, because there will generally only be one such definition in the `/etc/krb5.conf` file.
 
Note however that a different approach to the test can be declared as well. We could state that the object is the `[libdefaults]` section inside the `/etc/krb5.conf` file, and the state is the value `true` for the `forwardable` key. In this case, the test declares that multiple objects must exist, and (at least) one must match the state.
 
As you can see, the OVAL language tries to map definitions to unambiguous definitions. So, how does this look like in OVAL XML?
 
**The OVAL XML structure**
 
The [full example][fullexample] contains a few more entries than those we declare next, in order to be complete. The most important definitions though are documented below.
 
[fullexample]: {static}/static/2018/oval.xml
 
Let's start with the definition. As stated, it will refer to tests that need to match for the definition to be valid.
 
```
<definitions>
  <definition id="oval:com.example.oval:def:1" version="1" class="compliance">
    <metadata>
      <title>libdefaults.forwardable in /etc/krb5.conf must be set to true</title>
      <affected family="unix">
        <platform>Red Hat Enterprise Linux 7</platform>
      </affected>
      <description>
        By default, tickets obtained from the Kerberos environment must be forwardable.
      </description>
    </metadata>
    <criteria operator="AND">
      <criterion test_ref="oval:com.example.oval:tst:1" comment="Red Hat Enterprise Linux is installed"/>
      <criterion test_ref="oval:com.example.oval:tst:2" comment="/etc/krb5.conf's libdefaults.forwardable is set to true"/>
    </criteria>
  </definition>
</definitions>
```
 
The first thing to keep in mind is the (weird) identification structure. Just like with XCCDF, it is not sufficient to have your own id convention. You need to start an id with `oval:` followed by the reverse domain definition (here `com.example.oval`), followed by the type (`def` for definition) and a sequence number.
 
Also, take a look at the criteria. Here, two tests need to be compliant (hence the `AND` operator). However, more complex operations can be done as well. It is even allowed to nest multiple criteria, and refer to previous definitions, like so (taken from the [ssg-rhel6-oval.xml file][ssgrhel6oval]:
 
[ssgrhel6oval]: https://raw.githubusercontent.com/GovReady/ubuntu-scap/master/ssg-rhel6-oval.xml
 
```
<criteria comment="package hal removed or service haldaemon is not configured to start" operator="OR">
  <extend_definition comment="hal removed" definition_ref="oval:ssg:def:211"/>
  <criteria operator="AND" comment="service haldaemon is not configured to start">
    <criterion comment="haldaemon runlevel 0" test_ref="oval:ssg:tst:212"/>
    <criterion comment="haldaemon runlevel 1" test_ref="oval:ssg:tst:213"/>
    <criterion comment="haldaemon runlevel 2" test_ref="oval:ssg:tst:214"/>
    <criterion comment="haldaemon runlevel 3" test_ref="oval:ssg:tst:215"/>
    <criterion comment="haldaemon runlevel 4" test_ref="oval:ssg:tst:216"/>
    <criterion comment="haldaemon runlevel 5" test_ref="oval:ssg:tst:217"/>
    <criterion comment="haldaemon runlevel 6" test_ref="oval:ssg:tst:218"/>
  </criteria>
</criteria>
```
 
Next, let's look at the tests.
 
```
<tests>
  <unix:file_test id="oval:com.example.oval:tst:1" version="1" check_existence="all_exist" check="all" comment="/etc/redhat-release exists">
    <unix:object object_ref="oval:com.example.oval:obj:1" />
  </unix:file_test>
  <ind:textfilecontent54_test id="oval:com.example.oval:tst:2" check="all" check_existence="all_exist" version="1" comment="The value of forwardable in /etc/krb5.conf">
    <ind:object object_ref="oval:com.example.oval:obj:2" />
    <ind:state state_ref="oval:com.example.oval:ste:2" />
  </ind:textfilecontent54_test>
</tests>
```
 
There are two tests defined here. The first test just checks if `/etc/redhat-release` exists. If not, then the test will fail and the definition itself will result to false (as in, not compliant). This isn't actually a proper definition, because you want the test to not run when it is on a different platform, but for the sake of example and simplicity, let's keep it as is.
 
The second test will check for the value of the `forwardable` key in `/etc/krb5.conf`. For it, it refers to an object and a state. The test states that all objects must exist (`check_existence="all_exist"`) and that all objects must match the state (`check="all"`).
 
The object definition looks like so:
 
```
<objects>
  <unix:file_object id="oval:com.example.oval:obj:1" comment="The /etc/redhat-release file" version="1">
    <unix:filepath>/etc/redhat-release</unix:filepath>
  </unix:file_object>
  <ind:textfilecontent54_object id="oval:com.example.oval:obj:2" comment="The forwardable key" version="1">
    <ind:filepath>/etc/krb5.conf</ind:filepath>
    <ind:pattern operation="pattern match">^\s*forwardable\s*=\s*((true|false))\w*</ind:pattern>
    <ind:instance datatype="int" operation="equals">1</ind:instance>
  </ind:textfilecontent54_object>
</objects>
```
The first object is a simple file reference. The second is a text file content object. More specifically, it matches the line inside `/etc/krb5.conf` which has `forwardable = true` or `forwardable = false` in it. An expression is made on it, so that we can refer to the subexpression as part of the test.
 
This test looks like so:
 
```
<states>
  <ind:textfilecontent54_state id="oval:com.example.oval:ste:2" version="1">
    <ind:subexpression datatype="string">true</ind:subexpression>
  </ind:textfilecontent54_state>
</states>
```
 
This test refers to a subexpression, and wants it to be `true`.
 
**Testing the checks with Open-SCAP**
 
The Open-SCAP tool is able to test OVAL statements directly. For instance, with the above definition in a file called `oval.xml`:
 
```
~$ oscap oval eval --results oval-results.xml oval.xml
Definition oval:com.example.oval:def:1: true
Evaluation done.
```
 
The output of the command shows that the definition was evaluated successfully. If you want more information, open up the `oval-results.xml` file which contains all the details about the test. This results file is also very useful while developing OVAL as it shows the entire result of objects, tests and so forth.
 
For instance, the `/etc/redhat-release` file was only checked to see if it exists, but the results file shows what other parameters can be verified with it as well:
 
```
<unix-sys:file_item id="1233781" status="exists">
  <unix-sys:filepath>/etc/redhat-release</unix-sys:filepath>
  <unix-sys:path>/etc</unix-sys:path>
  <unix-sys:filename>redhat-release</unix-sys:filename>
  <unix-sys:type>regular</unix-sys:type>
  <unix-sys:group_id datatype="int">0</unix-sys:group_id>
  <unix-sys:user_id datatype="int">0</unix-sys:user_id>
  <unix-sys:a_time datatype="int">1515186666</unix-sys:a_time>
  <unix-sys:c_time datatype="int">1514927465</unix-sys:c_time>
  <unix-sys:m_time datatype="int">1498674992</unix-sys:m_time>
  <unix-sys:size datatype="int">52</unix-sys:size>
  <unix-sys:suid datatype="boolean">false</unix-sys:suid>
  <unix-sys:sgid datatype="boolean">false</unix-sys:sgid>
  <unix-sys:sticky datatype="boolean">false</unix-sys:sticky>
  <unix-sys:uread datatype="boolean">true</unix-sys:uread>
  <unix-sys:uwrite datatype="boolean">true</unix-sys:uwrite>
  <unix-sys:uexec datatype="boolean">false</unix-sys:uexec>
  <unix-sys:gread datatype="boolean">true</unix-sys:gread>
  <unix-sys:gwrite datatype="boolean">false</unix-sys:gwrite>
  <unix-sys:gexec datatype="boolean">false</unix-sys:gexec>
  <unix-sys:oread datatype="boolean">true</unix-sys:oread>
  <unix-sys:owrite datatype="boolean">false</unix-sys:owrite>
  <unix-sys:oexec datatype="boolean">false</unix-sys:oexec>
  <unix-sys:has_extended_acl datatype="boolean">false</unix-sys:has_extended_acl>
</unix-sys:file_item>
```
 
Now, this is just on OVAL level. The final step is to link it in the XCCDF file.
 
**Referring to OVAL in XCCDF**
 
The XCCDF Rule entry allows for a `check` element, which refers to an automated check for compliance.
 
For instance, the above rule could be referred to like so:
 
```
<Rule id="xccdf_com.example_rule_krb5-forwardable-true">
  <title>Enable forwardable tickets on RHEL systems</title>
  ...
  <check system="http://oval.mitre.org/XMLSchema/oval-definitions-5">
    <check-content-ref href="oval.xml" name="oval:com.example.oval:def:1" />
  </check>
</Rule>
```
 
With this set in the Rule, Open-SCAP can validate it while checking the configuration baseline:
 
```
~$ oscap xccdf eval --oval-results --results xccdf-results.xml xccdf.xml
...
Title   Enable forwardable kerberos tickets in krb5.conf libdefaults
Rule    xccdf_com.example_rule_krb5-forwardable-tickets
Ident   RHEL7-01007
Result  pass
```
 
A huge advantage here is that, alongside the detailed results of the run, there is also better human readable output as it shows the title of the Rule being checked.
 
**The detailed capabilities of OVAL**
 
In the above example I've used two examples: a file validation (against `/etc/redhat-release`) and a file content one (against `/etc/krb5.conf`). However, OVAL has many more checks and support for it, and also has constraints that you need to be aware of.
 
In the [OVAL Project][ovalproject] github account, the Language repository keeps track of the current documentation. By browsing through it, you'll notice that the OVAL capabilities are structured based on the target technology that you can check. Right now, this is AIX, Android, Apple iOS, Cisco ASA, Cisco CatOS, VMWare ESX, FreeBSD, HP-UX, Cisco iOS and iOS-XE, Juniper JunOS, Linux, MacOS, NETCONF, Cisco PIX, Microsoft SharePoint, Unix (generic), Microsoft Windows, and independent.
 
[ovalproject]: https://github.com/OVALProject/Language/tree/master/docs
 
The [independent][independent] one contains tests and support for resources that are often reusable toward different platforms (as long as your OVAL and XCCDF supporting tools can run it on those platforms). A few notable supporting tests are:
 
[independent]: https://github.com/OVALProject/Language/blob/master/docs/independent-definitions-schema.md
 
- `filehash58_test` which can check for a number of common hashes (such as SHA-512 and MD5). This is useful when you want to make sure that a particular (binary or otherwise) file is available on the system. In enterprises, this could be useful for license files, or specific library files.
- `textfilecontent54_test` which can check the content of a file, with support for regular expressions.
- `xmlfilecontent_test` which is a specialized test toward XML files
 
Keep in mind though that, as we have seen above, INI files specifically have no specialization available. It would be nice if CISecurity would develop support for common textual data formats, such as CSV (although that one is easily interpretable with the existing ones), JSON, YAML and INI.
 
The [unix][unix] one contains tests specific to Unix and Unix-like operating systems (so yes, it is also useful for Linux), and together with the [linux][linux] one a wide range of configurations can be checked. This includes support for generic extended attributes (`fileextendedattribute_test`) as well as SELinux specific rules (`selinuxboolean_test` and `selinuxsecuritycontext_test`), network interface settings (`interface_test`), runtime processes (`process58_test`), kernel parameters (`sysctl_test`), installed software tests (such as `rpminfo_test` for RHEL and other RPM enabled operating systems) and more.
 
[unix]: https://github.com/OVALProject/Language/blob/master/docs/unix-definitions-schema.md
[linux]: https://github.com/OVALProject/Language/blob/master/docs/linux-definitions-schema.md

