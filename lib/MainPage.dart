import 'package:flutter/material.dart';
import 'ThemeColor.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


final List<String> imgList =[
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
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
                              child: Image.network(
                            item,
                            fit: BoxFit.cover,
                            height: height,
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
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          communityTitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          
                        ),
                        SizedBox(width: 193),
                        TextButton(
                          onPressed: (){}, 
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
      
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(Icons.sunny, color: Colors.orange, size: 20,),
          Text(
                "오늘은 날씨 맑음! 빨래하기 좋은 날~",
                style: TextStyle(height: 2.5, fontSize: 14,),
              ),
        ],
      ),
    );
  }

  // Widget _buildItemWidget(DocumentSnapshot doc) {
    
  // }


  
}
