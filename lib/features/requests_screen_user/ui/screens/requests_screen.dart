import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/widgets/filter.dart';
import '../../../home_screen/ui/screens/home_screen.dart';
import '../../data/repo/requests_repo.dart';
import '../../manager/requests_user_cubit.dart';
import '../../manager/state/requests_user_state.dart';
import '../widgets/request_card_widget.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) =>
      RequestsCubit(RequestsRepo(ApiService()))..getRequests(),

      child: const RequestsView(),
    );
  }
}

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() =>
      _RequestsViewState();
}

class _RequestsViewState
    extends State<RequestsView> {

  String selectedTab = "All";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// 🔹 Header
            Padding(
              padding: const EdgeInsets.all(16),

              child: Row(
                children: [

                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(),
                        ),
                      );
                    },

                    child: const Icon(
                      Icons.arrow_back,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    "My Requests".tr(),

                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,

                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 Filter Tabs
            Filter(

              selectedTab: selectedTab,

              onTabChanged: (tab) {

                setState(() {

                  selectedTab = tab;
                });
              },
            ),

            const SizedBox(height: 10),

            /// 🔹 Requests List
            Expanded(
              child: BlocBuilder<
                  RequestsCubit,
                  RequestsState>(

                builder: (
                    context,
                    state,
                    ) {

                  /// LOADING
                  if (state
                  is RequestsLoading) {

                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  /// ERROR
                  if (state
                  is RequestsError) {

                    return Center(
                      child: Text(
                        state.message,
                      ),
                    );
                  }

                  /// SUCCESS
                  if (state
                  is RequestsSuccess) {

                    final filteredRequests =
                    state.requests.where((
                        request,
                        ) {

                      if (selectedTab == "All") {
                        return true;
                      }

                      return request.status.toLowerCase() == selectedTab.toLowerCase();

                    }).toList();

                    if (filteredRequests
                        .isEmpty) {

                      return Center(
                        child: Text(
                          "No Requests Found"
                              .tr(),
                        ),
                      );
                    }

                    return ListView.builder(

                      padding:
                      const EdgeInsets.all(
                        16,
                      ),

                      itemCount:
                      filteredRequests.length,

                      itemBuilder:
                          (context, index) {

                        final request =
                        filteredRequests[
                        index];

                        return RequestCardWidget(
                          request: request,
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}