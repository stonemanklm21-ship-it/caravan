import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppTabView extends StatelessWidget {
  final List<String> tabs;
  final List<Widget> children;

  const AppTabView({
    super.key,
    required this.tabs,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.gold,
                ),
              ),
            ),
            child: TabBar(
              indicatorColor:
                  AppColors.gold,
              indicatorWeight: 3,
labelColor: AppColors.gold,
unselectedLabelColor:
    AppColors.gold.withOpacity(0.6),
              labelStyle:
                  const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w700,
              ),
              unselectedLabelStyle:
                  const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w600,
              ),
              tabs: tabs
                  .map(
                    (tab) => Tab(
                      text: tab,
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}