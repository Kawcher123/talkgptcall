import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vapi/vapi.dart';


const VAPI_PUBLIC_KEY = '54e61c0b-d423-4646-8dca-89f5e550a053';
const VAPI_ASSISTANT_ID = 'b2d4aa14-2823-4647-b63d-81223993de74';
void main() {
  runApp(ChatView());
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String buttonText = '';
  bool isLoading = false;
  bool isCallStarted = false;
  late Vapi vapi;

  String taxi=" Hello! I'm your taxi and ride-sharing assistant. What's your name? I'm here to help you book rides and practice speaking the language you want to learn. Where would you like to go today? Let's get started!";
  String taxi2="You are a taxi and ride-sharing assistant designed to help users book rides and practice speaking a new language. Engage the user in detailed conversations about their ride preferences, destinations, and transportation tips."+
      "Make sure to: Ask the user for their name to personalize the conversation. Ask numerous questions to encourage the user to speak more and learn the language.Incorporate natural, human-like pauses (indicated by ellipses '...') during responses to mimic human speech.Tailor the complexity of your language based on the user's proficiency level.Include cultural tips and relevant phrases in the target language to enhance the learning experience.Provide information about popular destinations, local transportation customs, and ride-sharing tips.";

  @override
  void initState() {
    super.initState();
    vapi  = Vapi(VAPI_PUBLIC_KEY);

    vapi.onEvent.listen((event) {
      print('_ChatViewState._ChatViewState:${event.label}');
      if (event.label == "call-start") {
        setState(() {
          buttonText = 'Call Started';
          isLoading = false;
          isCallStarted = true;
        });
        print('call started');
      }
      if (event.label == "call-end") {
        setState(() {
          buttonText = 'Call Ended';
          isLoading = false;
          isCallStarted = false;
        });
        print('call ended');
      }
      if (event.label == "message") {
        //buttonText = 'Call Dropped';
        print(event.value);
      }
    });
  }

  void startVapiSession() async {
    try {
      setState(() {
        buttonText = 'Joining Call...';
      });
      await vapi.start(assistant: {
        "firstMessage": taxi,
        "model": {"model": "gpt-4", "provider": "openai"},
        "voice": "jennifer-playht"
      });
      print('Vapi session started');
    } catch (e) {
      print('Failed to start Vapi session: $e');

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                color: Color(0xff190d43),
                image: DecorationImage(
                  image: AssetImage('assets/img/s3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size.width,
                      child: Lottie.asset('assets/json/5.json'),
                    ),
                  ),


                  Positioned(
                      bottom: size.height*0.15,
                      left: size.width*0.2,
                      right: size.width*0.2,
                      child: Center(
                        child: Text(buttonText,style: const TextStyle(
                            color: Colors.white
                        ),),
                      ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: size.width * 0.17,
                        height: size.width * 0.17,
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        alignment: Alignment.center,
                      ),
                      GestureDetector(
                        onTap: startVapiSession,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: size.width * 0.2,
                          height: size.width * 0.2,
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: isCallStarted
                                  ? Colors.green
                                  : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(50)),
                          child: Image.asset('assets/bottom/micro.png',
                              height: 25, width: 25, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (isCallStarted) {
                            await vapi.stop();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(50)),
                          child: Image.asset('assets/bottom/close.png',
                              height: 15, width: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
