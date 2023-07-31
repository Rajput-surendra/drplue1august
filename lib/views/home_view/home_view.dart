

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dr_plus/Utils/colors.dart';
import 'package:dr_plus/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {



  @override
  Widget build(BuildContext context) {
    final heightSize = MediaQuery.of(context).size.height;
    final widthSize = MediaQuery.of(context).size.width;
    return GetBuilder(
      init: HomeController(),
      builder:(controller) {
      return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Alert"),
                content: const Text("Are you sure you want to exit?."),
                actions: <Widget>[
                  ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(primary: AppColors.primary),
                    child: const Text("YES"),
                    onPressed: () {
                      controller.onTapSignupScreen();
                     // exit(0);
                      // SystemNavigator.pop();
                    },
                  ),
                  ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(primary: AppColors.primary),
                    child: const Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
          return shouldPop!;
        },
        child: Scaffold(
         // key: controller.scaffoldKey,
          backgroundColor: AppColors.lightwhit,
          appBar: AppBar(
            centerTitle: true,
              flexibleSpace: Container(
                decoration:BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[AppColors.secondary.withOpacity(0.1),AppColors.secondary])),
              ),
             title: InkWell(
               onTap: () {
                Navigator.pop(context);
               },
                 child: Text('${controller.signupController.selectedPlace}',style: const TextStyle(fontWeight: FontWeight.w400,fontSize:16),)),
            // leading: InkWell(
            //     onTap: () {
            //       //controller.getDrawer();
            //       controller.scaffoldKey.currentState!.openDrawer();
            //     },
            //     child: const Icon(Icons.dehaze_rounded)),

            actions: [
              Image.asset("assets/images/dr_plus_logo.png",height: 50,width: 50,)
            ],

          ),
          drawer: controller.getDrawer(),
          //drawer: controller.scaffoldKey.currentState!.openDrawer(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height:15,),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  child: TextFormField(
                    controller: controller.searchController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintText: 'Search here'),
                    onChanged: (value) {
                      controller.searchProduct(value);
                    },
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 15,),
                controller.isBusy ? const Center(child: CircularProgressIndicator(color: AppColors.secondary,),)  :
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                              onPageChanged: (index, result) {
                                controller.currentPost1 = index;
                                controller.update();
                              },
                              viewportFraction: 1.0,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlayAnimationDuration:
                              Duration(milliseconds: 500),
                              enlargeCenterPage: false,
                              scrollDirection: Axis.horizontal,
                              height: 180.0),

                          items:controller.getBannerResponseModel1?.data?.map((val) {
                            print('_____controller.sliderList__ddddddddddddddddddddddddd___${controller.getBannerResponseModel1?.data?.length}_________');
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    height: heightSize/4.6,
                                    width: widthSize/1,
                                    child:Image.network("${val.image}",fit: BoxFit.cover,));
                              },
                            );
                          }).toList(),

                        ),
                        const SizedBox(height:10,),
                        Positioned(
                          bottom: 20,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: controller.buildDots1(),),
                          ),
                        ),
                      ],
                    ),
                const SizedBox(height: 20,),
                controller.isBusy ? const Center(child: CircularProgressIndicator(color: AppColors.secondary,),) : SizedBox(
                  // height: heightSize/0.7,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: controller.categoryList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:4,
                      mainAxisSpacing:5,
                        mainAxisExtent: 120
                      ),
                    itemBuilder:(context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.getSliderData1 ();
                                controller.onTapDoctorList(index);
                              },
                              child: Container(
                                height:70,
                                width: 70,
                                decoration: BoxDecoration(
                                    gradient:const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[AppColors.secondary,AppColors.primary]),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child:Image.network(controller.categoryList[index].image??'',scale:1.5,)
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              width: 91,
                                child: Text(controller.categoryList[index].name??'',
                                  style:TextStyle(fontSize: 10,fontWeight: FontWeight.w500),overflow: TextOverflow.visible,maxLines: 2,textAlign: TextAlign.center,)),
                          ],
                        );

                      },),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      );
    },);
  }

  // getCatApi(){
  //   var headers = {
  //     'Cookie': 'ci_session=f103a4bfa5ff5540ff7b91b298c8be18b4386964'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/dr_booking/user/app/v1/api/get_doctors'));
  //   request.fields.addAll({
  //     'category_id': '13',
  //     'area_id': '1',
  //     'user_id': '456'
  //   });
  //
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   }
  //   else {
  //   print(response.reasonPhrase);
  //   }
  //
  // }
}


