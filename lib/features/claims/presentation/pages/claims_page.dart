import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../cubit/claim_cubit.dart';
import '../cubit/claim_state.dart';

class ClaimPage extends StatelessWidget {
  const ClaimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Claims')),
      body: BlocListener<ClaimCubit, ClaimState>(
        listener: (context, state) {
          if (state is ClaimError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<ClaimCubit, ClaimState>(
          builder: (context, state) {
            if (state is ClaimInitial || state is ClaimLoading) {
              Modular.get<ClaimCubit>().fetchClaims();
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClaimLoaded) {
              return ListView.builder(
                itemCount: state.claims.length,
                itemBuilder: (_, i) {
                  final claim = state.claims[i];
                  return Card(
                    child: ListTile(
                      title: Text(claim.title, style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(claim.body, maxLines: 2,),
                      onTap: () => Modular.to.pushNamed('/detail', arguments: claim),
                    ),
                  );
                },
              );
            } else if (state is ClaimError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
