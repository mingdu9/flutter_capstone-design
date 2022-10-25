import 'package:capstone1/firstPages/tutorialTabs.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 5, initialIndex: 0,vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( backgroundColor: Colors.white, elevation: 0,
          title: TabPageSelector(
            controller: _tabController,
            selectedColor: Colors.black,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  FirstTab(), SecondTab(), ThirdTab(), FourthTab(), LastTab()
                ],
              ),
            ),
          ],
        )
    );
  }
}

