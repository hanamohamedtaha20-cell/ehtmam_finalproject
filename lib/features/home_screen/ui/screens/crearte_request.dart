import 'package:ehtemam_final_project/core/network/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/create_request_cubit.dart';
import '../widgets/create_req_widgets/create_request_body.dart';
import '../../data/repo/create_request_repo.dart';
import '../../data/repo/create_request_remote_datasource.dart';

class CreateRequestScreen extends StatelessWidget {
  final String serviceId;
  final String serviceName;
  final String serviceType;

  const CreateRequestScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
    this.serviceType = '',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateRequestCubit(
        CreateRequestRepositoryImpl(
          CreateRequestRemoteDatasourceImpl(ApiService()),
        ),
      ),
      child: CreateRequestBody(
        serviceId:   serviceId,
        serviceName: serviceName,
        serviceType: serviceType,
      ),
    );
  }
}