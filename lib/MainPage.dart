import 'package:flutter/material.dart';
import 'ThemeColor.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


final List<String> imgList =[
  'assets/1.png',
  'assets/2.png',
  'assets/1.png',
  'assets/1.png',
  'assets/1.png',
];
// w=1951&q=80



class MainPage extends StatelessWidget {
  
  MainPage({Key? key}) : super(key: key);
  late List<String> items;

  @override
  Widget build(BuildContext context) {
    items = List<String>.generate(5, (i) => 'Item $i');


    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2!,

      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  carouselSlide(),
                  weatherText(),
                  textList('인기글'),
                  textList('최신글')
                ],
              ),
            ),
          );
        },
      )
    );

    // return Scaffold(
    //   body: Column(
    //     children: <Widget>[
    //       carouselSlide(),
    //       weatherText(),
    //       textList(),
    //       textList()
    //     ],
    // ));
  }

  Expanded newMethod() {
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        // prototypeItem: ListTile(
        //   title: Text(items.first),
        // ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index], style: TextStyle(fontSize: 13)
                ),
              );
            },
          ),
        );
  }

  

  Widget carouselSlide() {
    return Container(
      child: Builder(
            builder: (context) {
              final double height = MediaQuery.of(context).size.height;
              return CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlayAnimationDuration: Duration(milliseconds: 400),
                  autoPlay: true,
                ),
                items: imgList
                    .map((item) => Container(
                          child: Center(
                              child: Image( 
                                image: AssetImage(item)
                          )),
                        ))
                    .toList(),
              );
            },
          ),
    );
  }

  Container textList(String communityTitle) {
      return Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color.fromARGB(66, 74, 74, 74),
                width: 1,
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Color.fromARGB(31, 208, 208, 208),
              //   )
              // ]
              ),
          height: 210,
          
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        
                        Text(
                          communityTitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          
                        ),
                        SizedBox(height: 50,),
                        TextButton(
                          onPressed: (){
                              
                          }, 
                          child: Text("더 보기 >", style: TextStyle(fontSize: 13)),
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory
                          )
                        )
                      ],
                    ),
                    visualDensity: VisualDensity(vertical: -4),
                  ),
                  ListTile(
                    title: Text('안녕', style: TextStyle(fontSize: 13)),
                    visualDensity: VisualDensity(vertical: -4),
                    dense: true,
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('afsd', style: TextStyle(fontSize: 13)),
                    visualDensity: VisualDensity(vertical: -4),
                    dense: true,
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('afsd', style: TextStyle(fontSize: 13)),
                    visualDensity: VisualDensity(vertical: -4),
                    dense: true,
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('afsd', style: TextStyle(fontSize: 13)),
                    visualDensity: VisualDensity(vertical: -4),
                    dense: true,
                    onTap: () {},
                  ),
                  
                ],
              ),
            ),
            
    
            ],
          )
        );
    
  }
  

  Container weatherText() {
    return Container(
      height: 50,
      
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          Icon(Icons.sunny, color: Colors.orange, size: 20,),
          Text(
            " 오늘은 날씨 맑음! 빨래하기 좋은 날~",
            style: TextStyle(height: 2.5, fontSize: 14,),
          ),
        ],
      ),
    );
  }

  // Widget _buildItemWidget(DocumentSnapshot doc) {
    
  // }


  
}
