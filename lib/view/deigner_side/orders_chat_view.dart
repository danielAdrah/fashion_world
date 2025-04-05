// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../theme.dart';
import 'orders_view.dart';

class OrdersChatView extends StatefulWidget {
  const OrdersChatView({super.key});

  @override
  State<OrdersChatView> createState() => _OrdersChatViewState();
}

class _OrdersChatViewState extends State<OrdersChatView>
    with TickerProviderStateMixin {
  late TabController tabCont;
  int selectedIndex = 0;
  int currentTab = 0;
  List tabs = ["Orders", "Chat"];

  @override
  void initState() {
    super.initState();
    tabCont = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: TColor.background,
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                tabs: tabs.map<Widget>((e) {
                  return Tab(
                    child: Text(e),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  children: [OrdersView(), Text("1")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
