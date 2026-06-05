import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/create_request_cubit.dart';
import '../widgets/create_req_widgets/create_request_body.dart';

class CreateRequestScreen extends StatelessWidget {
  const CreateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateRequestCubit(),

      child: const CreateRequestBody(),
    );
  }
}