import 'dart:js';
import 'package:flutter/material.dart';
import 'package:a_living_dictionary/main.dart';
import 'ThemeColor.dart';

/* 백과사전: 청소, 빨래, 요리, 기타 */

ThemeColor themeColor = ThemeColor();
int _curIndex = 0;

class DictionaryPage extends StatelessWidget {
  const DictionaryPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:

        Column(
          children: [
            Expanded(
                child:
                ListView(
                  children: [
                    mySearch(),
                    myList(),
                    myButton(context),
                    

                  ],
                ))
          ],
        ),



    );
  }


/* --------------------------------------------------------- */

  Widget myTempSearch() { // TODO: 검색 디자인
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 4),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Color(0xfff2f3f6),
            ),

            child: Row(
              children: [

                IconButton(
                  onPressed: () => {},
                  icon: Icon(Icons.search_rounded, color: Color(0xff81858d)),
                ),
                Text("검색", style: TextStyle(color: Color(0xff81858d)),),


              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget myButton(BuildContext context) { // TODO : 버튼 화면 전환
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          width: double.infinity,
          height: 85,
          child: SizedBox(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff122eff),
                    padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23)
                    )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => btnClean()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("청소 / 빨래", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                  ],
                )
            ),
          ),
        ),



        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          width: double.infinity,
          height: 85,
          child: SizedBox(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffffae00),
                    padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23)
                    )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => btnCook()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("요리", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                  ],
                )
            ),
          ),
        ),


        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          width: double.infinity,
          height: 85,
          child: SizedBox(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff9c00ff),
                    padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23)
                    )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => btnLaundry()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("집 꾸미기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                  ],
                )
            ),
          ),
        ),


        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          width: double.infinity,
          height: 85,
          child: SizedBox(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff445061),
                    padding: EdgeInsets.fromLTRB(27, 0, 27, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23)
                    )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => btnEtc()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("기타", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                  ],
                )
            ),
          ),
        ),







        Container(
          margin: EdgeInsets.fromLTRB(10,10, 10, 10),
          width: double.infinity,
          height: 250,
          child:
          InkWell(
            onTap: () {}, // Handle your callback.
            splashColor: Colors.brown.withOpacity(0.5),
            child: Ink(
              // width: 100,
              // height: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff8a8a8a).withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 5.0,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
              borderRadius: BorderRadius.circular(23),
                image: DecorationImage(
                  image: AssetImage('assets/1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ),

      ],
    );
  }



  Widget myList(){ // TODO: 인기글
    return Column(
      children: [

        Container(
          margin: EdgeInsets.all(14),
          padding: EdgeInsets.fromLTRB(10, 9, 10, 10),
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(
            //   color: Color.fromARGB(66, 74, 74, 74),
            // ),
            boxShadow: [
              BoxShadow(
                color: Color(0xffb1b1b1).withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 5.0,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [

              ListTile(
                title: Row(
                  children: [
                    Text("인기 TIP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Icon(Icons.star, color: Colors.orange, size: 20,),
                  ],
                ),
              ),


              ListTile(
                title: Text('Best 1', style: TextStyle(fontSize: 15)),
                visualDensity: VisualDensity(vertical: -4),
                dense: true,
                onTap: () {},
              ),

              ListTile(
                title: Text('Best 2', style: TextStyle(fontSize: 15)),
                visualDensity: VisualDensity(vertical: -4),
                dense: true,
                onTap: () {},
              ),

              ListTile(
                title: Text('Best 3', style: TextStyle(fontSize: 15)),
                visualDensity: VisualDensity(vertical: -4),
                dense: true,
                onTap: () {},
              ),

            ],
          ),
        )

      ],
    );
  }

  Widget mySearch(){
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xff81858d)),
          filled: true,
          fillColor: Color(0xfff2f3f6),
          hintText: '검색',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );


  }

}


Widget getPage() {
  switch(_curIndex){
    case 0: return btnClean();
    case 1: return btnLaundry();
    case 2: return btnCook();
    default: return DictionaryPage();
  }
}



/* --------------------------------------------------------- */

// class SecondPage extends StatelessWidget {
//   const SecondPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ElevatedButton(
//         child: Text('Previous Page'),
//         onPressed: (){ Navigator.pop(context); },
//       ),
//     );
//   }
// }

class btnClean extends StatelessWidget {
  const btnClean({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        child: Text('청소 페이지'),
        onPressed: (){ Navigator.pop(context); },
      ),
    );
  }
}

class btnLaundry extends StatelessWidget {
  const btnLaundry({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ElevatedButton(
        child: Text('빨래 페이지'),
        onPressed: (){ Navigator.pop(context); },
      ),
    );
  }
}

class btnCook extends StatelessWidget {
  const btnCook({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        child: Text('요리 페이지'),
        onPressed: (){ Navigator.pop(context); },
      ),
    );
  }
}

class btnEtc extends StatelessWidget {
  const btnEtc({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        child: Text('기타 페이지'),
        onPressed: (){ Navigator.pop(context); },
      ),
    );
  }
}