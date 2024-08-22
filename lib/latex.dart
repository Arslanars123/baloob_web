import 'dart:convert';
import 'package:baloonproject/latex_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;



class BalloonTabScreen extends StatefulWidget {
  @override
  _BalloonTabScreenState createState() => _BalloonTabScreenState();
}

class _BalloonTabScreenState extends State<BalloonTabScreen> {
  List<Map<String, String>> categories = [];
  Map<String, List<Balloon>> balloonsData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.post(Uri.parse('http://92.112.194.129:3000/get-subs'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          setState(() {
            categories = data.map<Map<String, String>>((category) {
              return {
                'id': category['_id'],
                'name': category['name']
              };
            }).toList();
            isLoading = false;
          });

          if (categories.isNotEmpty) {
            _fetchBalloons(categories[0]['id']!);
          }
        } else {
          throw FormatException('Expected a list, but got: ${data.runtimeType}');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> _fetchBalloons(String subId) async {
    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/get-baloons-by-sub'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'subId': subId}),
      );
      print("herere");
print(subId);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("testing phase jkewbkcbkwcbkcbwkc");
            print(data);
        if (data is List) {
          setState(() {
            balloonsData[subId] = data.map<Balloon>((balloon) => Balloon.fromJson(balloon)).toList();
          });
        } else {
          throw FormatException('Expected a list, but got: ${data.runtimeType}');
        }
      } else {
        print('Failed to load balloons. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    indicatorColor: Color(0xFF055C9D),
                    labelColor: Color(0xFF055C9D),
                    unselectedLabelColor: Colors.black,
                    labelStyle: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: categories.map((category) => Tab(text: category['name'])).toList(),
                    onTap: (index) {
                      final categoryId = categories[index]['id']!;
                      if (!balloonsData.containsKey(categoryId)) {
                        _fetchBalloons(categoryId);
                      }
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      children: categories.map((category) {
                        final categoryId = category['id']!;
                        return balloonsData.containsKey(categoryId)
                            ? BalloonWrapView(balloons: balloonsData[categoryId]!)
                            : Center(child: CircularProgressIndicator());
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class BalloonWrapView extends StatelessWidget {
  final List<Balloon> balloons;

  BalloonWrapView({required this.balloons});

  @override
  Widget build(BuildContext context) {
    print("jkbcsdckjskbsjkcbcjkbsjkcsbkjcsbcsdjk");
    print(balloons.length);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 14, // Spacing between items in the main axis
        runSpacing: 8.0, // Spacing between items in the cross axis
        children: balloons.map((balloon) => BalloonCard(balloon: balloon)).toList(),
      ),
    );
  }
}
class BalloonCard extends StatelessWidget {
  final Balloon balloon;

  BalloonCard({required this.balloon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(balloon.price);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage2(baloon: balloon),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              balloon.imageUrl,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              },
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                balloon.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(
                '\$${balloon.price}',
                style: GoogleFonts.lato(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
