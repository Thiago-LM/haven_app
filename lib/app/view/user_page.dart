import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/app/app.dart';
import 'package:haven_app/app/cubit/wallpaper_cubit.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  WallpaperCubit get cubit => context.read<WallpaperCubit>();

  final _textController = TextEditingController();

  Future<void> apikeyValidation() async {
    final value = _textController.text;

    await cubit.validateApikey(apikey: value);

    if (cubit.state.userStatus == UserStatus.success) {
      log('apikey success = $value', name: 'UserPage');
      final purity =
          cubit.state.wallQuery.purity?.toList() ?? [true, false, null];

      if (purity.last == null) {
        purity.last = false;
      }

      cubit.updateWallpaperQuery(
        cubit.state.wallQuery.copyWith(
          purity: purity,
          apikey: value,
        ),
      );
    } else {
      final purity =
          cubit.state.wallQuery.purity?.toList() ?? [true, false, null];

      if (purity.last != null) {
        purity.last = null;
      }

      cubit.updateWallpaperQuery(
        cubit.state.wallQuery.copyWith(purity: purity, apikey: ''),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (cubit.state.wallQuery.apikey != null) {
      _textController.text = cubit.state.wallQuery.apikey!;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Text(
            'User',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Insert your API key here',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'API key',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final data = await Clipboard.getData('text/plain');
                        if (data != null && data.text != null) {
                          setState(() {
                            _textController.text = data.text!;
                          });
                        }
                      },
                      icon: const Icon(Icons.paste_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async => apikeyValidation(),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(16),
                      ),
                    ),
                    child: const Text('Validate'),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<WallpaperCubit, WallpaperState>(
                  builder: (context, state) {
                    switch (state.userStatus) {
                      case UserStatus.initial:
                        return Container();
                      case UserStatus.loading:
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      case UserStatus.failure:
                        return const Center(
                          child: Text(
                            'Apikey is not valid',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      case UserStatus.success:
                        return const Center(
                          child: Text(
                            "You're good to go!",
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
