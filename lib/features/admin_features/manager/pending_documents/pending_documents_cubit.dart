import 'package:bloc/bloc.dart';
import 'package:ehtemam_final_project/features/admin_features/manager/pending_documents/pending_documents_state.dart';

class PendingDocumentsCubit
    extends Cubit<PendingDocumentsState> {

  PendingDocumentsCubit()
      : super(const PendingDocumentsState());

  Future<void> getDocuments() async {}

  Future<void> approveProvider() async {}

  Future<void> rejectProvider() async {}
}