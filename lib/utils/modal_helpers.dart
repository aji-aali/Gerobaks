import 'package:flutter/material.dart';
import 'package:bank_sha/models/information_model.dart';
import 'package:bank_sha/ui/widgets/modals/detail_information_modal.dart';

void showInformationDetailModal(BuildContext context, InformationModel information, {int? currentIndex}) {
  int index = currentIndex ?? informationList.indexOf(information);
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    useSafeArea: true,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: DetailInformationModal(
          information: information,
          currentIndex: index,
          onPrevious: index > 0 ? () {
            // Close current modal
            Navigator.pop(context);
            
            // Show previous item
            showInformationDetailModal(
              context, 
              informationList[index - 1], 
              currentIndex: index - 1
            );
          } : null,
          onNext: index < informationList.length - 1 ? () {
            // Close current modal
            Navigator.pop(context);
            
            // Show next item
            showInformationDetailModal(
              context, 
              informationList[index + 1], 
              currentIndex: index + 1
            );
          } : null,
        ),
      );
    },
  );
}
