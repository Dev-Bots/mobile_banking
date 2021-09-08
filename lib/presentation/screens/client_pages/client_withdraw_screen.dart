// import 'package:mobile_banking/application/bloc/TransactionBloc/login_bloc.dart';
// import 'package:mobile_banking/application/bloc/AuthBloc/auth_bloc.dart';
import 'dart:io';

import 'package:mobile_banking/application/bloc/TransactionBloc/transaction_bloc.dart';
// import 'package:mobile_banking/insfrastructure/data_provider/auth/accountProvider.dart';
import 'package:mobile_banking/insfrastructure/data_provider/transaction/transactionProvider.dart';
// import 'package:mobile_banking/insfrastructure/repository/auth/accountRepository.dart';
import 'package:mobile_banking/insfrastructure/repository/transaction/TransactionRepository.dart';
import 'package:mobile_banking/presentation/config/route_generator.dart';
import 'package:mobile_banking/presentation/screens/client_pages/client_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'client_pages_frame.dart';

class ClientWithdrawPage extends StatelessWidget {
  final accountTextController = TextEditingController();
  final amountTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final repo = TransactionRepository(
      dataProvider: TransactionDataProvider(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    // final authBloc = BlocProvider.of<AuthBloc>(context);

    // final transactionBloc = BlocProvider.of<TransactionBloc>(context).state;
    final inputFieldStyle = InputDecoration(
      border: OutlineInputBorder(),
    );

    return BlocProvider(
      create: (context) => TransactionBloc(transactionRepository: repo),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          iconTheme: IconThemeData(color: Colors.blue),
          backgroundColor: Colors.white38,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BankImage(),
                      SizedBox(height: 20.0),
                      AmountField(amountTextController: amountTextController),
                      SizedBox(height: 20.0),
                      ReceiverAccountField(
                          accountTextController: accountTextController),
                      SizedBox(height: 30.0),
                      StateCheckBloc(
                          amountTextController: amountTextController,
                          accountTextController: accountTextController),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StateCheckBloc extends StatelessWidget {
  const StateCheckBloc({
    Key? key,
    required this.amountTextController,
    required this.accountTextController,
  }) : super(key: key);

  final TextEditingController accountTextController;
  final TextEditingController amountTextController;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TransactionBloc>(context).state;
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, transactionState) {
        if (transactionState is ClientWithdrawProcessing) {
          // final snackBar = SnackBar(content: Text("Login in progress"));

          CircularProgressIndicator();
        }

        if (transactionState is ClientWithdrawSuccess) {
          String message = transactionState.withdrawMessage;

          final snackBar = SnackBar(content: Text(message));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          sleep(Duration(seconds: 1));

          // Navigator.of(context).pushNamed(RouteGenerator.TransferPageRoute);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClientDashboard()),
          );

          // Navigator.pop(context);
        }

        if (transactionState is ClientWithdrawFailure) {
          // buttonChild = Text(authState.errorMsg);

          final snackBar = SnackBar(content: Text(transactionState.error));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (ctx, authState) {
        Widget buttonChild = Text("Withdraw");

        return TransferButton(
            amountTextController: amountTextController,
            accountTextController: accountTextController,
            buttonChild: buttonChild);
      },
    );
  }
}

class BankImage extends StatelessWidget {
  const BankImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: MediaQuery.of(context).size.height / 3,

      // decoration: BoxDecoration(color: Colors.black),
      child: Image.asset('assets/images/transfer.jpg'),
    );
  }
}

class TransferButton extends StatelessWidget {
  const TransferButton({
    Key? key,
    required this.amountTextController,
    required this.accountTextController,
    required this.buttonChild,
  }) : super(key: key);

  final TextEditingController accountTextController;
  final TextEditingController amountTextController;
  final Widget buttonChild;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final transactionBloc = BlocProvider.of<TransactionBloc>(context);

        transactionBloc.add(ClientWithdrawButtonPressed(
            amount: double.parse(amountTextController.text),
            agentAccount: accountTextController.text));
      },
      child: buttonChild,
    );
  }
}

class AmountField extends StatelessWidget {
  const AmountField({
    Key? key,
    required this.amountTextController,
  }) : super(key: key);

  final TextEditingController amountTextController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: amountTextController,
      decoration: InputDecoration(
        icon: Icon(Icons.attach_money),
        hintText: "Amount",
      ),
    );
  }
}

class ReceiverAccountField extends StatelessWidget {
  const ReceiverAccountField({
    Key? key,
    required this.accountTextController,
  }) : super(key: key);

  final TextEditingController accountTextController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: accountTextController,
      decoration: InputDecoration(
        icon: Icon(Icons.account_box_sharp),
        hintText: "Agent Account Number",
      ),
    );
  }
}
