import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF40BF5),
                      Color(0xFFBF46BE),
                      Color(0xFFF40BF5)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.arrow_back_rounded, size: 30),
              ),
              SizedBox(
                  width: 8), // Add some space between the icon and the text
              Text('Terms and Conditions'),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              '1. READ THIS:',
              style: TextStyle(
                fontSize: 24, // Adjust the font size for the heading
                fontWeight: FontWeight.bold, // Make the heading bold
              ),
            ),
            SizedBox(height: 10),
            Text(
                "This Terms of Use Agreement (“Agreement” or “Terms of Use”) is made by and between BangAppTz, a Tanzanian corporation, with offices at 654 Mwinjuma Street, Box #13022, Dar es Salaam, TZ (“BANGAPP TZ”) and you (“you,” “your” or “User”). This Agreement contains the terms and conditions that govern your use of this App."),
            SizedBox(height: 10),
            Text(
                "BY ACCESSING OR ATTEMPTING TO INTERACT WITH ANY PART OF THIS APP, OR OTHER BANGAPP SOFTWARE, SERVICES, APP OR ANY OF BANGAPP TZ LICENSEES’ SERVICES (COLLECTIVELY “SERVICES”), YOU AGREE THAT YOU HAVE READ, UNDERSTAND AND AGREE TO BE BOUND BY THIS AGREEMENT. IF YOU DO NOT AGREE TO BE BOUND BY THIS AGREEMENT, DO NOT ACCESS OR USE ANY PART OF THIS APP."),
            SizedBox(height: 10),
            Text(
                "BANGAPP TZ RESERVES THE RIGHT, FROM TIME TO TIME, WITH OR WITHOUT NOTICE TO YOU, TO MAKE CHANGES TO THIS AGREEMENT IN BANGAPP TZ’S SOLE DISCRETION. CONTINUED USE OF ANY PART OF THIS APP CONSTITUTES YOUR ACCEPTANCE OF SUCH CHANGES. THE MOST CURRENT VERSION OF THIS AGREEMENT, WHICH SUPERSEDES ALL PREVIOUS VERSIONS, CAN BE REVIEWED BY CLICKING ON THE TERMS OF USE HYPERLINK LOCATED AT THE BOTTOM OF EVERY PAGE ON THIS APP."),
            SizedBox(height: 10),
            Text(
                "No implication is made that the materials published on BANGAPP APP(s) are appropriate for use outside of the Tanzania. If you access this app from outside of the Tanzania, you do so on your own initiative and you are responsible for compliance with local laws. Additionally, this app is published in english and we are not responsible for errors in translation."),
            SizedBox(height: 10),
            Text("2. ACCESS TO THIS SITE",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "To access this site or some of the resources it offers, you may be asked to provide certain registration details or other information. It is a condition of your use of this site that all the information you provide on this site will be correct, current, and complete. If BANGAPP believes the information you provide is not correct, current, or complete, BANGAPP has the right to refuse you access to this site or any of its resources, and to terminate or suspend your access at any time."),
            SizedBox(height: 10),
            Text("3. RESTRICTIONS ON USE",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "You may use this site for purposes expressly permitted by this site. As a condition of your use of BANGAPP's app(s), you warrant to BANGAPP that you will not use the app(s) for any purpose that is unlawful or prohibited by these terms, conditions, and notices. For example, you may not (and may not authorize any party to) (i) co-brand this site, or (ii) frame this site, or (iii) download any content from this site (other than as provided by these terms) without the express prior written permission of an authorized representative of BANGAPP.  For purposes of these Terms of Use, co-branding means to display a name, logo, trademark, or other means of attribution or identification of any party in such a manner as is reasonably likely to give a user the impression that such other party has the right to display, publish, or distribute this site or content accessible within this site. You agree to cooperate with BANGAPP to prevent or remedy any unauthorized use. In addition, you may not use BANGAPP's app(s) in any manner which could disable, overburden, damage, or impair the app(s) or interfere with any other party's use and enjoyment of the app(s). You may not obtain or attempt to obtain any materials, content, or information through any means not intentionally made available or provided for through the app(s)."),
            SizedBox(height: 10),
            Text("4.  PERSONAL AND NON-COMMERCIAL USE LIMITATION",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "BANGAPP's app(s) are for your personal and non-commercial use, unless otherwise specified. You may not use this app for any other purpose, including any commercial purpose, without BANGAPP's express prior written consent. You may not modify, copy, distribute, display, send, perform, reproduce, publish, license, create derivative works from, transfer, or sell any information, content, software, products or services obtained from or otherwise connected to BANGAPP's APP(s), unless expressly permitted by these terms."),
            SizedBox(height: 10),
            Text("5.  PROPRIETARY INFORMATION",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "The material and content accessible from this site, and any other app owned, operated, licensed, or otherwise controlled by BANGAPP (the “Content”) is the proprietary information of BANGAPP or the party that provided or licensed the Content to BANGAPP whereby such providing party retains all right, title, and interest in the Content. Accordingly, the Content may not be copied, distributed, republished, uploaded, posted, or transmitted in any way without the prior written consent of BANGAPP, except that you may print out a copy of the Content solely for your personal use, and you may re-post a single image and up to one hundred (100) words of continuous text from any article if such posting provides a right of attribution to BANG APP TZ, and promotes the article on other apps, including social media sites.  In doing so, you may not remove or alter, or cause to be removed or altered, any copyright, trademark, trade name, service mark, or any other proprietary notice or legend appearing on any of the Content.  Modification or use of the Content except as expressly provided in these Terms of Use violates BANGAPP's intellectual property rights. Neither title nor intellectual property rights are transferred to you by access to this site.From time to time, the app will utilize various plugins or widgets to allow sharing of content via social media channels, email or other methods. Use of these plugins or widgets does not constitute any waiver of BANGAPP’s intellectual property rights. Such use is a limited license to republish the content on the approved social media channels, with full credit to the app."),
            SizedBox(height: 10),
            Text("6.  LINKS TO THIRD-PARTY APPS",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            Text(
                "This site may link to other sites which are not maintained by, or related to, BANGAPP. You represent and warrant that you have read and agree to be bound by all applicable Terms of Use and policies for any third-party apps. Links to such sites are provided as a service to users and are not sponsored by or affiliated with this site or BANGAPP.  BANGAPP has not reviewed any or all of such sites and is not responsible for the content of those sites. Links are to be accessed at the user's own risk, and BANGAPP makes no representations or warranties about the content, completeness or accuracy of the sites linked to or from this site. You expressly hold BANGAPP harmless from any and all liability related to your use of a third-party app. BANGAPP provides links as a convenience, and the inclusion of any link to a third-party site does not imply endorsement by BANGAPP of that site or any association with its operators."),
            SizedBox(height: 10),
            Text("7.  USE OF COMMUNICATION SERVICES",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "BANG APP's apps may contain comment boxes, forums, bulletin board services, chat areas, message boards, news groups, communities, personal web pages, calendars, and/or other message or communication facilities designed to allow you to communicate with the Internet community or with a group (collectively, “Communications Services”). You agree to use the Communication Services only to post, send and receive messages and content that are proper and related to the particular Communication Service. Users agree to adhere to this Terms of Use agreement when using BANGAPP’s Communication Services.When using the Communication Services, you agree that you will not post, send, submit, publish, or transmit in connection with this site any material that:"),
            ListTile(
                title: Text(
                    '1. You do not have the right to post, including proprietary material of any third party, such as files containing software or other material protected by intellectual property laws (or by rights of privacy or publicity')),
            ListTile(
                title: Text(
                    '2. Advocates illegal activity or discusses an intent to commit an illegal act')),
            ListTile(
                title: Text('3. Is vulgar, obscene, ***ographic, or indecent')),
            ListTile(title: Text('4. Does not pertain directly to this site')),
            ListTile(
                title: Text(
                    '5. Threatens or abuses others, libels, defames, invades privacy, stalks, is obscene, ***ographic, racist, abusive, harassing, threatening or offensive')),
            ListTile(
                title: Text(
                    '6. Seeks to exploit or harm children by exposing them to inappropriate content, asking for personally identifiable details or otherwise')),
            ListTile(
                title: Text(
                    '7. Harvests or otherwise collects information about others, including e-mail addresses, without their consent')),
            ListTile(
                title: Text(
                    '8.Violates any law or may be considered to violate any law')),
            ListTile(
                title: Text(
                    '9. Impersonates or misrepresents your connection to any other entity or person or otherwise manipulates headers or identifiers to disguise the origin of the content')),
            ListTile(
                title: Text(
                    '10. Falsifies or deletes any author attributions, legal or other proper notices or proprietary designations or labels of the origin or source of software or other material contained in a file that is permissibly uploaded')),
            ListTile(
                title: Text(
                    '11. Advertises any commercial endeavor (e.g., offering for sale products or services) or otherwise engages in any commercial activity (e.g., conducting raffles or contests, displaying sponsorship banners, and/or soliciting goods or services) except as may be specifically authorized on this site')),
            ListTile(
                title: Text('12. Solicits funds, advertisers or sponsors')),
            ListTile(
                title: Text(
                    '13. Includes programs that contain viruses, worms and/or Trojan horses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of any computer software or hardware or telecommunications')),
            ListTile(
                title: Text(
                    '14. Disrupts the normal flow of dialogue, causes a screen to scroll faster than other users are able to type, or otherwise act in a way which affects the ability of other people to engage in real time activities via this site')),
            ListTile(title: Text('15. Includes MP3 format files')),
            ListTile(
                title: Text(
                    '16. Amounts to a pyramid or other like scheme, including contests, chain letters, and surveys')),
            ListTile(
                title: Text(
                    '17. Disobeys any policy or regulations including any code of conduct or other guidelines, established from time to time regarding use of this site or any networks connected to this site; or')),
            ListTile(
                title: Text(
                    '18. Contains hyper-links to other sites that contain content that falls within the descriptions set forth above')),
            Text(
                "BANGAPP reserves the right to monitor use of this site to determine compliance with these Terms of Use, as well as the right to remove or refuse any information for any reason. BANGAPP reserves the right to terminate your access to any or all of the Communication Services at any time without notice for any reason whatsoever. BANGAPP also reserves the right at all times to disclose any information as necessary to satisfy any applicable law, regulation, legal process or governmental request, or to edit, refuse to post or to remove any information or materials, in whole or in part, in its sole discretion. Materials uploaded to a Communication Service may be subject to posted limits on use, reproduction and/or dissemination and you are responsible for abiding by such limitations with respect to your submissions, including any downloaded materials.Notwithstanding these rights, you remain solely responsible for the content of your submissions. You acknowledge and agree that neither BANGAPP nor any third party that provides Content to BANGAPP will assume or have any liability for any action or inaction by BANGAPP or such third party with respect to any submission. BANGAPP cautions you against giving out any personally identifying information about yourself in any Communication Service. BANGAPP does not control or endorse the content, messages or information found in any Communication Service and, consequently, BANGAPP specifically disclaims any liability with respect to the Communication Services and any actions resulting from your participation in any Communication Service. Managers and hosts are not authorized BANGAPP spokespersons, and their views do not necessarily reflect those of BANGAPP."),
            SizedBox(height: 10),
            Text("8.  SUBMISSIONS",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "Unless you and BANGAPP enter into a separate written contract for use of your Content that states otherwise, you hereby grant to BANGAPP the royalty-free, perpetual, irrevocable, worldwide, non-exclusive right and license to use, reproduce, modify, adapt, publish, translate, create derivative works from, distribute, perform, and display all content, remarks, suggestions, ideas, graphics, or other information communicated to BANGAPP through this site (together, the “Submission”), and to incorporate any Submission in other works in any form, media, or technology now known or later developed. BANGAPP will not be required to treat any Submission as confidential, and may use any Submission in its business (including without limitation, for products or advertising) without incurring any liability for royalties or any other consideration of any kind, and will not incur any liability as a result of any similarities that may appear in future BANGAPP operations."),
            Text("9.  DISCLAIMER",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "BANGAPP has made every effort to ensure that all information on the app has been tested for accuracy. BANGAPP make no guarantees regarding the results that you will see from using the information provided on the app.The app was developed strictly for informational purposes. You understand and agree that you are fully responsible for your use of the information provided on the app. BANGAPP makes no representations, warranties, or guarantees. You understand that results may vary from person to person. BANGAPP assumes no responsibility for errors or omissions that may appear on the app.You understand that BANGAPP cannot and does not guarantee or warrant that files available for downloading from the Internet will be free of viruses, worms, Trojan horses or other code that may manifest contaminating or destructive properties. The app is provided on an “as is” and “as available” basis without any representations or warranties, expressed or implied. You are responsible for implementing sufficient procedures and checkpoints to satisfy your particular requirements for accuracy of data input and output, and for maintaining a means external to this site for any reconstruction of any lost data. BANGAPP does not assume any responsibility or risk for your use of the Internet.The Content is not necessarily complete and up-to-date and should not be used to replace any written reports, statements, or notices provided by BANGAPP.YOUR USE OF THIS SITE IS AT YOUR OWN RISK. THE CONTENT IS PROVIDED AS IS AND WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED. BANGAPP DISCLAIMS ALL WARRANTIES, INCLUDING ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, OR NON-INFRINGEMENT. BANGAPP DOES NOT WARRANT THAT THE FUNCTIONS OR CONTENT CONTAINED IN THIS SITE WILL BE UNINTERRUPTED OR ERROR-FREE, THAT DEFECTS WILL BE CORRECTED, OR THAT THIS SITE OR THE SERVER THAT MAKES IT AVAILABLE ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS. BANGAPP DOES NOT WARRANT OR MAKE ANY REPRESENTATION REGARDING USE, OR THE RESULT OF USE, OF THE CONTENT IN TERMS OF ACCURACY, RELIABILITY, OR OTHERWISE. THE CONTENT MAY INCLUDE TECHNICAL INACCURACIES OR TYPOGRAPHICAL ERRORS, AND BANGAPP MAY MAKE CHANGES OR IMPROVEMENTS AT ANY TIME. YOU, AND NOT BANGAPP, ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION IN THE EVENT OF ANY LOSS OR DAMAGE ARISING FROM THE USE OF THIS SITE OR ITS CONTENT. BANGAPP MAKES NO WARRANTIES THAT YOUR USE OF THE CONTENT WILL NOT INFRINGE THE RIGHTS OF OTHERS AND ASSUMES NO LIABILITY OR RESPONSIBILITY FOR ERRORS OR OMISSIONS IN SUCH CONTENT.All of the information in this site, whether historical in nature or forward-looking, speaks only as of the date the information is posted on this site, and BANGAPP does not undertake any obligation to update such information after it is posted or to remove such information from this site if it is not, or is no longer accurate or complete."),
            SizedBox(height: 10),
            Text("10.  LIMITATION ON LIABILITY",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "BANGAPP, ITS SUBSIDIARIES, AFFILIATES, LICENSORS, SERVICE PROVIDERS, CONTENT PROVIDERS, EMPLOYEES, AGENTS, OFFICERS, AND DIRECTORS WILL NOT BE LIABLE FOR ANY INCIDENTAL, DIRECT, INDIRECT, PUNITIVE, ACTUAL, CONSEQUENTIAL, SPECIAL, EXEMPLARY, OR OTHER DAMAGES, INCLUDING LOSS OF REVENUE OR INCOME, PAIN AND SUFFERING, EMOTIONAL DISTRESS, OR SIMILAR DAMAGES, EVEN IF BANGAPP HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES."),
            SizedBox(height: 10),
            Text("11.  TERMINATION OR RESTRICTION OF ACCESS",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "BANGAPP reserves the right, in its sole discretion, to terminate your access to any or all of BANGAPP's apps and the related services or any portion thereof at any time, without notice."),
            SizedBox(height: 10),
            Text("12.  INDEMNITY",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "You will indemnify and hold BANGAPP, its subsidiaries, affiliates, licensors, content providers, service providers, employees, agents, officers, directors, and contractors (the “Indemnified Parties”) harmless from any breach of these Terms of Use by you, including any use of Content other than as expressly authorized in these Terms of Use. You agree that the Indemnified Parties will have no liability in connection with any such breach or unauthorized use, and you agree to indemnify any and all resulting loss, damages, judgments, awards, costs, expenses, and attorneys' fees of the Indemnified Parties in connection therewith. You will also indemnify and hold the Indemnified Parties harmless from and against any claims brought by third parties arising out of your use of the information accessed from this site."),
            SizedBox(height: 10),
            Text("13.  TRADEMARKS AND COPYRIGHTS",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "The trademarks, trade names, service marks, and logos (“Trademarks”) appearing on this App, including without limitation BANG APP TZ® and/or its distinctive logo.  All other content on this App (“Copyrights”), including all page headers, custom graphics, button icons, and scripts are copyrighted works of BANGAPP, and may not be copied, imitated or used, in whole or in part, without the prior written permission of BANGAPP.  From time to time, the app will legally utilize intellectual property owned by third parties related to our services.  The rights in any third party trademarks or copyrighted works on this App are retained by their respective owners.  Nothing in this Agreement shall confer any right of ownership of any of the Trademarks or Copyrights to you.  Further, nothing in this Agreement shall be construed as granting, by implication, estoppel or otherwise, any license or right to use any Trademark or Copyright without the express written permission of BANGAPP.  The misuse of the Trademark or Copyrighted works displayed in this site, or any other content on the site, is strictly prohibited and may expose you to liability. All contents of BANGAPP's apps are: Copyright © BANG APP TZ.  All rights reserved."),
            SizedBox(height: 10),
            Text("14.  COPYRIGHT INFRINGEMENT",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 5),
            Text("Notice and Takedown Procedure",
                style: TextStyle(
                  fontSize: 24, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "BANGAPP expeditiously responds to valid notices of copyright infringement that adhere to the requirements set forth in the Digital Millennium Copyright Act (DMCA). If you believe that your work has been copied in a way that constitutes copyright infringement, you may provide BANGAPP's Designated Agent (listed below) with a notice that contains all six points enumerated below (preferably via email).Upon receipt of a valid notice, BANGAPP will remove or disable access to the allegedly infringing content as well as make a good-faith attempt to contact the owner or administrator of the affected content so they may counter-notice pursuant to Sections 512(g)(2) and (3) of the DMCA."),
            ListTile(
                title: Text(
                    "1. An electronic or physical signature of the person authorized to act on behalf of the owner of the copyright interest;")),
            ListTile(
                title: Text(
                    "2.	A description of the copyrighted work that you claim has been infringed upon;")),
            ListTile(
                title: Text(
                    "3.	A description of where the material that you claim is infringing is located on the site, including the URL, if applicable;")),
            ListTile(
                title: Text(
                    "4.	Your address, telephone number, and e-mail address;")),
            ListTile(
                title: Text(
                    "5.	A statement by you that you have a good-faith belief that the disputed use is not authorized by the copyright owner, its agent, or the law; and,")),
            ListTile(
                title: Text(
                    "6.	A statement by you, made under penalty of perjury, that the above information in your notice is accurate and that you are the copyright owner or authorized to act on the copyright owner's behalf.")),
            SizedBox(height: 5),
            Text(
                "Be aware that a notice must contain all six points for BANGAPP to take action. All other notices will be ignored."),
            SizedBox(height: 5),
            Text("Designated Agent:",
                style: TextStyle(
                  fontSize: 20, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text("BANGAPP’s Designated Agent can be can be contacted at:"),
            ListTile(title: Text("BANG APP TZ")),
            ListTile(title: Text("654 Mwinjuma Street")),
            ListTile(title: Text("Box #13022")),
            ListTile(title: Text("Dar Es Salaam, TZ")),
            ListTile(
              title: Text("Phone: +255 710426568"),
            ),
            ListTile(
              title: Text("e-mail: support@bangapp.pro"),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Counter-Notification Procedure",
                style: TextStyle(
                  fontSize: 20, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 5),
            Text(
                "The provider of the allegedly infringing content may make a counter-notification pursuant to sections 512(g)(2) and (3) of the DMCA. To file a counter-notification with BANGAPP please provide BANGAPP’s Designated Agent (listed above) with the following information (preferably via email):"),
            ListTile(
                title: Text(
                    "1.	Identification of the material that has been removed or to which access has been disabled and the location at which the material appeared before it was removed or access to it was disabled;")),
            ListTile(
                title: Text("2.	Your name, address, and telephone number;")),
            ListTile(
                title: Text(
                    "3.	The following statement: “I consent to the jurisdiction of Federal District Court for the [insert the federal judicial district in which your address is located]”;")),
            ListTile(
                title: Text(
                    "4.	The following statement: “I will accept service of process from [insert the name of the person who submitted the infringement notification] or his/her agent”;")),
            ListTile(
                title: Text(
                    "5.	The following statement: “I swear, under penalty of perjury, that I have a good faith belief that the affected material was removed or disabled as a result of a mistake or misidentification of the material to be removed or disabled”; and")),
            ListTile(
                title:
                    Text("6.	Your signature, in physical or electronic form.")),
            SizedBox(height: 5),
            Text(
                "Upon receipt of a counter-notification containing all six points, BANGAPP will promptly provide the person who provided the original takedown notification with a copy of the counter-notification, and inform that person that BANGAPP will replace the removed material or cease disabling access to it in 10 business days.Finally, if BANGAPP’s Designated Agent receives notification from the person who submitted the original takedown notification within 14 days of receipt of the counter-notification that an action has been filed seeking a court order to restrain the alleged infringer from engaging in infringing activity relating to the material on its system, then BANGAPP will once again remove the file from its system."),
            SizedBox(height: 10),
            Text("Repeat Infringers",
                style: TextStyle(
                  fontSize: 20, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "In accordance with Section 512(i)(1)(a) of the DMCA, BANGAPP will, in appropriate circumstances, disable and/or terminate the accounts of users who are repeat infringers."),
            Text("Accommodation of Standard Technical Measures.",
                style: TextStyle(
                  fontSize: 20, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "It is BANGAPP's policy to accommodate and not interfere with standard technical measures used by copyright owners to identify or protect copyrighted works that BANGAPP determines are reasonable under the circumstances."),
            SizedBox(height: 10),
            Text("15.  SECURITY",
                style: TextStyle(
                  fontSize: 20, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "Any passwords used for this site are for individual use only. You will be responsible for the security of your password (if any). BANGAPP will be entitled to monitor your password and, at its discretion, require you to change it. If you use a password that BANGAPP considers insecure, BANGAPP will be entitled to require the password to be changed and/or terminate your account.You are prohibited from using any services or facilities provided in connection with this site to compromise security or tamper with system resources and/or accounts. The use or distribution of tools designed for compromising security (e.g., password guessing programs, cracking tools or network probing tools) is strictly prohibited. If you become involved in any violation of system security, BANGAPP reserves the right to release your details to system administrators at other sites in order to assist them in resolving security incidents. BANGAPP reserves the right to investigate suspected violations of these Terms of Use.BANGAPP reserves the right to fully cooperate with any law enforcement authorities or court order requesting or direction BANGAPP to disclose the identity of anyone posting any e-mail messages, or publishing or otherwise making available any materials that are believed to violate these Terms of Use. BY ACCEPTING THIS AGREEMENT YOU WAIVE AND HOLD HARMLESS BANGAPP FROM ANY CLAIMS RESULTING FROM ANY ACTION TAKEN BY BANGAPP DURING OR AS A RESULT OF ITS INVESTIGATIONS AND/OR FROM ANY ACTIONS TAKEN AS A CONSEQUENCE OF INVESTIGATIONS BY EITHER BANGAPP OR LAW ENFORCEMENT AUTHORITIES."),
            SizedBox(height: 10),
            Text("16. PAYMENTS",
                style: TextStyle(
                  fontSize: 20, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            Text(
                "By accesing this application you agree to subjected to 30% deduction on earning you make on our platform."),
            SizedBox(height: 5),
            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Percentage',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Recipient',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            '30%',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Bangapp',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            '75%',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'You',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text("17.  MISCELLANEOUS",
                style: TextStyle(
                  fontSize: 20, // Adjust the font size for the heading
                  fontWeight: FontWeight.bold, // Make the heading bold
                )),
            SizedBox(height: 10),
            Text(
                "These Terms of Use will be governed and interpreted pursuant to the laws of California, United States of America, notwithstanding any principles of conflicts of law. You specifically consent to personal jurisdiction in California in connection with any dispute between you and BANGAPP arising out of these Terms of Use or pertaining to the subject matter hereof. The parties to these Terms of Use each agree that the exclusive venue for any dispute between the parties arising out of these Terms of Use will be in the state and federal courts in San Diego County, California."),
            SizedBox(height: 5),
            Text(
                "If any part of these Terms of Use is unlawful, void or unenforceable, that part will be deemed severable and will not affect the validity and enforceability of any remaining provisions."),
            SizedBox(height: 5),
            Text(
                "You agree that no joint venture, partnership, employment, or agency relationship exists between you and BANGAPP as a result of this agreement or use of BANGAPP’s apps."),
            SizedBox(height: 5),
            Text(
                "These Terms of Use constitute the entire agreement among the parties relating to this subject matter and supersedes all prior or contemporaneous communications and proposals, whether electronic, oral or written between the user and BANGAPP with respect to BANGAPP's apps."),
            SizedBox(height: 5),
            Text(
                "A printed version of this agreement and of any notice given in electronic form shall be admissible in judicial or administrative proceedings based upon or relating to this agreement to the same extent and subject to the same conditions as other business documents and records originally generated and maintained in printed form."),
            SizedBox(height: 5),
            Text(
                "The Terms of Use may not be assigned by you without our prior written consent, however, the Terms of Use may be assigned by us in our sole discretion."),
            SizedBox(height: 5),
            Text(
                "Notwithstanding the foregoing, any additional terms and conditions on this site will govern the items to which they pertain."),
            SizedBox(height: 5),
            Text(
                " BANGAPP may revise these Terms of Use at any time by updating this posting."),
          ]),
        ),
      ),
    );
  }
}
