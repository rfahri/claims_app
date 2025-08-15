import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../cubit/claim_cubit.dart';
import '../cubit/claim_state.dart';

class ClaimPage extends StatefulWidget {
  const ClaimPage({super.key});

  @override
  State<ClaimPage> createState() => _ClaimPageState();
}

class _ClaimPageState extends State<ClaimPage> {

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Claims')),
      body: BlocListener<ClaimCubit, ClaimState>(
        listener: (context, state) {
          if (state is ClaimError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search by title or description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ClaimCubit, ClaimState>(
                builder: (context, state) {
                  if (state is ClaimInitial || state is ClaimLoading) {
                    Modular.get<ClaimCubit>().fetchClaims();
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ClaimLoaded) {
                    final filteredClaims = state.claims.where((claim) {
                      return claim.title.toLowerCase().contains(_searchQuery) ||
                          claim.body.toLowerCase().contains(_searchQuery);
                    }).toList();
                    if (filteredClaims.isEmpty) {
                      return const Center(child: Text('No claims found'));
                    }
                    return ListView.builder(
                      itemCount: filteredClaims.length,
                      itemBuilder: (_, i) {
                        final claim = filteredClaims[i];
                        return Card(
                          child: ListTile(
                            title: Text(
                              claim.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(claim.body, maxLines: 2),
                            onTap: () => Modular.to.pushNamed(
                              '/detail',
                              arguments: claim,
                            ),
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
          ],
        ),
      ),
    );
  }
}
