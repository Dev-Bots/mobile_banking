import 'package:mobile_banking/presentation/screens/auth_page/login.dart';
import 'package:mobile_banking/presentation/widgets/bank_name.dart';
import 'package:mobile_banking/application/bloc/AuthBloc/auth_bloc.dart';
import 'package:mobile_banking/infrastructure/repository/auth/accountRepository.dart';
import 'package:mobile_banking/infrastructure/data_provider/auth/accountProvider.dart';
import 'package:mobile_banking/presentation/widgets/custom_admin_widgets/admin_menu.dart';
import 'package:mobile_banking/presentation/widgets/custom_client_widgets/client_menu.dart';
import 'package:mobile_banking/presentation/widgets/info_card.dart';
// import 'package:mobile_banking/presentation/widgets/menu_card_layout.dart';
import 'package:mobile_banking/presentation/widgets/name_card.dart';
import 'package:mobile_banking/presentation/theme/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AdminReport extends StatelessWidget {
  AdminReport({Key? key}) : super(key: key);

  final repo = AccountRepository(
      dataProvider: AccountDataProvider(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: this.repo,
      child: BlocProvider<AuthBloc>(
        create: (context) =>
            AuthBloc(accountRepository: this.repo)..add(GetMyAccount()),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is AccountLoading) {
            return CircularProgressIndicator();
          } else if (state is AccountLoaded) {
            var user = state.user;
            return Scaffold(
              backgroundColor: AppColors.primaryWhite,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    //Top Container
                    color: AppColors.primaryWhite,
                    child: Column(
                      children: [
                        BankName(),
                        NameCard('${user.fullName}', '${user.role}'),
                        InfoCard('Central Budget', 'A${user.accountNumber}',
                            '\$${user.bankBudget}'),
                        AdminMenuLayout(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return LoginScreen();
          }
        }),
      ),
    );
  }
}
