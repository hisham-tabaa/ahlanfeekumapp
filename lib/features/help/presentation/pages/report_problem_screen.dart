import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../data/models/create_ticket_request.dart';
import '../bloc/help_bloc.dart';
import '../bloc/help_event.dart';
import '../bloc/help_state.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('report_problem'.tr()),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppColors.textPrimary,
          fontSize: ResponsiveUtils.fontSize(
            context,
            mobile: 18,
            tablet: 20,
            desktop: 22,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocConsumer<HelpBloc, HelpState>(
        listener: (context, state) {
          if (state.ticketSubmitted) {
            context.showSnackBar('Ticket submitted successfully');
            Navigator.pop(context);
          }

          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            maxWidth: 700,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 28,
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(context),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'First Name',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 14,
                                  tablet: 15,
                                  desktop: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveUtils.spacing(
                                context,
                                mobile: 8,
                                tablet: 10,
                                desktop: 12,
                              ),
                            ),
                            CustomTextField(
                              controller: _firstNameController,
                              hintText: '',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveUtils.spacing(
                          context,
                          mobile: 16,
                          tablet: 17,
                          desktop: 18,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last Name',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 14,
                                  tablet: 15,
                                  desktop: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveUtils.spacing(
                                context,
                                mobile: 8,
                                tablet: 10,
                                desktop: 12,
                              ),
                            ),
                            CustomTextField(
                              controller: _lastNameController,
                              hintText: '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Problem',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 14,
                            tablet: 15,
                            desktop: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 8,
                          tablet: 10,
                          desktop: 12,
                        ),
                      ),
                      CustomTextField(
                        controller: _descriptionController,
                        hintText: '',
                        maxLines: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 32,
                      tablet: 34,
                      desktop: 36,
                    ),
                  ),
                  CustomButton(
                    text: 'Submit',
                    isLoading: state.isSubmitting,
                    onPressed: () {
                      if (_firstNameController.text.trim().isEmpty ||
                          _lastNameController.text.trim().isEmpty ||
                          _descriptionController.text.trim().isEmpty) {
                        context.showSnackBar(
                          'Please fill in all fields',
                          isError: true,
                        );
                        return;
                      }

                      final request = CreateTicketRequest(
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        description: _descriptionController.text.trim(),
                      );

                      context.read<HelpBloc>().add(SubmitTicketEvent(request));
                    },
                    backgroundColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 17, desktop: 18),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 17, desktop: 18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveUtils.size(
              context,
              mobile: 50,
              tablet: 55,
              desktop: 60,
            ),
            height: ResponsiveUtils.size(
              context,
              mobile: 50,
              tablet: 55,
              desktop: 60,
            ),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.headset_mic_outlined,
              color: Colors.orange,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 28,
                tablet: 30,
                desktop: 32,
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(
              context,
              mobile: 12,
              tablet: 13,
              desktop: 14,
            ),
          ),
          Expanded(
            child: Text(
              'Report a problem',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 16,
                  tablet: 17,
                  desktop: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
