import 'package:carsilla/globel_by_callofcoding.dart';
import 'package:carsilla/utils/theme.dart';
import 'package:carsilla/const/endpoints.dart';
import 'package:carsilla/services/NetworkApiService.dart';
import '../../utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../const/common_methods.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});
  
  
  Future<dynamic> getSupportData()async{
    final response = await ApiClass().getApiData("${Endpoints.baseUrl}getSupportDetails");
    return response['data'];
  }
  
  
  Widget contactTile(BuildContext context,{void Function()? onTap,required String label,required String imageName}){
    Size size = MediaQuery.of(context).size;
    return InkWell(
  onTap: onTap,
      child: Container(
        height: 65,
        width: size.width * 0.85,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(offset: Offset(0, 3),color: Colors.black12,blurRadius: 5,spreadRadius: 1)
            ],
            color: customColor("#fff2f4"),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MainTheme.primaryColor.shade100)
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/$imageName.png'),
              const SizedBox(width: 20,),
              Text(label,style: const TextStyle(fontSize: 21,fontFamily: "Inter",color: Colors.black,fontWeight: FontWeight.w600),)
            ],
          ),
        ),
      ),
    );
  }



  final String supportText = """
We value your experience and are committed to providing the best support possible. If you have any questions, issues, or feedback, please don't hesitate to reach out to us.""";

  @override
  Widget build(BuildContext context) {
    Size size = getMediaSize(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support',style: TextStyle(color: Colors.white),),backgroundColor: MainTheme.primaryColor,foregroundColor: Colors.white,centerTitle: true,),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: FutureBuilder(
          future: getSupportData(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator()
                ],
              );
            }
            if(snapshot.hasData && !snapshot.hasError){
              print('${snapshot.data}');
                return Column(
                children: [
                  const SizedBox(height: 18,),
                  const Text("Need Assistance? We're Here to Help!",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18,color: MainTheme.primaryColor),),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SelectableText(supportText,textAlign: TextAlign.center,textScaler: const TextScaler.linear(1.1),style: const TextStyle(color: Colors.black87),),
                  ),
                  const SizedBox(height: 40,),
                  contactTile(context, label: 'Call us', imageName: 'headphones-with-mic',onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: snapshot.data['contact'],
                    );
                    await canLaunchUrl(launchUri).then((value) async {
                      if(value){
                        await launchUrl(launchUri);
                      }else{
                        UiUtils(context).showSnackBar( 'Not able to open dial pad');
                      }
                    },);
                  }),
                  const SizedBox(height: 25,),
                  contactTile(context, label: 'Email us', imageName: 'email',onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: snapshot.data['email'],
                      query: 'subject=${Uri.encodeComponent("Help & Support")}&body=${Uri.encodeComponent("")}',
                    );
                    await canLaunchUrl(emailUri).then((value) async {
                      if(value){
                        await launchUrl(emailUri);
                      }else{
                        UiUtils(context).showSnackBar( 'Not able to launch email');
                      }
                    },);
                  }),
                  const SizedBox(height: 25,),
                  contactTile(context, label: 'Message us', imageName: 'whatsapp-logo',onTap: () async {
                    String mapsUrl =
                        "https://wa.me/${snapshot.data['whatsapp']}";
                    final Uri _url = Uri.parse(
                        mapsUrl);
                    await canLaunchUrl(_url).then((value) async {
                      if(value){
                        await launchUrl(_url);
                      }else{
                        UiUtils(context).showSnackBar( "Not able to open WhatsApp");
                      }
                    },);

                  })

                ],
              );
            }
            return const SizedBox();
          }
        ),
      ),
    );
  }
}
