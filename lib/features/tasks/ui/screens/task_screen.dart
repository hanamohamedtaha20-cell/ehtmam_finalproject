import 'package:ehtemam_final_project/core/resources/app_colors.dart';

import 'package:ehtemam_final_project/features/tasks/manager/task_cubit.dart';

import 'package:ehtemam_final_project/features/tasks/manager/task_state.dart';

import 'package:ehtemam_final_project/features/tasks/ui/widgets/search_field.dart';

import 'package:ehtemam_final_project/features/tasks/ui/widgets/stats_row.dart';

import 'package:ehtemam_final_project/features/tasks/ui/widgets/tab_bar.dart';

import 'package:ehtemam_final_project/features/tasks/ui/widgets/task_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';



import '../../../requests_screen_user/ui/screens/requests_screen.dart';

import '../widgets/add_task_dialog.dart';
import 'package:easy_localization/easy_localization.dart';



class TaskScreen extends StatelessWidget {

  final String requestId;



  const TaskScreen({super.key, required this.requestId});



  @override

  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) => TaskCubit(requestId: requestId)..loadTasks(),

      child: const _TaskScreenBody(),

    );

  }

}



class _TaskScreenBody extends StatelessWidget {

  const _TaskScreenBody();



  @override

  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: const Color(0xFFF5F5F5),

        body: SafeArea(

          child: Padding(

            padding:  EdgeInsets.all(16.r),

            child: BlocBuilder<TaskCubit, TaskState>(

              builder: (context, state) {

                if (state is TaskLoading || state is TaskInitial) {

                  return Center(child: CircularProgressIndicator());

                }

                if (state is TaskError) {

                  return Center(child: Text(state.message));

                }

                if (state is! TaskLoaded) return SizedBox.shrink();

                return Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    /// Header

                    Row(

                      children: [

                        GestureDetector(

                            onTap: () {

                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder: (context) => RequestsScreen(),

                                ),

                              );

                            },

                            child: Icon(Icons.arrow_back)),

                         Text('my_tasks'.tr(), style: TextStyle(fontFamily: "Arimo", fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.textDark)),

                         Spacer(),

                     //localization

                      ],

                    ),

                     SizedBox(height: 16.h),



                    /// Stats

                    StatsRow(activeCount: state.activeCount, completedCount: state.completedCount),

                     SizedBox(height: 16.h),





                    /// Tab Bar

                       TaskTabs(

                        selectedIndex: state.selectedTab,

                        allCount: state.tasks.length,

                        activeCount: state.activeCount,

                        completedCount: state.completedCount,

                        onTap: (i) => context.read<TaskCubit>().selectTab(i),

                      ),

                    SizedBox(height: 12.h),



                    /// Task List

                    Expanded(

                      child: TaskList(

                        tasks: state.filtered,

                        onToggle: (id) => context.read<TaskCubit>().toggleTask(id),

                        onDelete: (id) => context.read<TaskCubit>().deleteTask(id),

                      ),

                    ),



                    /// Progress



                  ],

                );

              },

            ),

          ),

        ),

        floatingActionButton: FloatingActionButton(

          backgroundColor: Color(0xff3A8BD7),

          shape: const CircleBorder(),

          child: Icon(Icons.add, color: Colors.white),

          onPressed: () => showAddTaskDialog(context),

        ),



      );

  }

}


