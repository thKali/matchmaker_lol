import 'package:app/app/app_module.dart';
import 'package:app/app/core/presenter/common_widgets/fmm_button.dart';
import 'package:app/app/rift/domain/entities/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routefly/routefly.dart';

import '../../domain/entities/player.dart';
import '../../domain/state/rift_state.dart';
import '../../domain/stores/rift_store.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final riftStore = appInjector.get<RiftStore>();

  String get roomId => Routefly.query['id'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: riftStore,
      builder: (context, snapshot) {
        final state = riftStore.value;
        final players = state.room.players.toList();
        final isOwner = state.player.id == state.room.hostID;

        final hasMatch =
            state.room.teams.isNotEmpty && state is! ErrorRiftState;

        final canCreateMatch =
            state.room.players == 10 && state is! ErrorRiftState;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    flex: 3,
                    child: Text(
                      'Flutterando\nMatchMaker',
                      style: TextStyle(color: Colors.white, fontSize: 42),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 6,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0XFF1D1B20),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: TextFormField(
                                        initialValue: state.player.name,
                                        key: Key(state.player.id),
                                        onChanged: (value) {
                                          final player = state.player
                                              .copyWith(name: value);
                                          riftStore.updatePlayer(player);
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'NickName',
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                          hintStyle: const TextStyle(
                                              color: Colors.white),
                                          fillColor: const Color(0XFF36343B),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Flexible(
                                      flex: 4,
                                      child: Wrap(
                                        spacing: 5,
                                        runSpacing: 6,
                                        runAlignment: WrapAlignment.center,
                                        alignment: WrapAlignment.center,
                                        children: List.generate(
                                            Role.values.length, (index) {
                                          final role = Role.values[index];
                                          return ChoiceChip(
                                            label: Text(
                                              role.name.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            selectedColor:
                                                const Color(0XFF6750A4),
                                            selected: role == state.player.role,
                                            padding: const EdgeInsets.all(4),
                                            backgroundColor:
                                                const Color(0XFF1D1B20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              side: const BorderSide(
                                                color: Color(0XFFCAC4D0),
                                                width: 3,
                                              ),
                                            ),
                                            onSelected: (selected) {
                                              if (selected) {
                                                final player = state.player
                                                    .copyWith(role: role);
                                                riftStore.updatePlayer(player);
                                              }
                                            },
                                          );
                                        }),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (state.error != null) ...[
                                      Text(
                                        state.error?.message ?? '',
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                    Flexible(
                                      flex: 4,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 6,
                                        runSpacing: 10,
                                        children: [
                                          FMMButton(
                                            backgroundColor:
                                                state.player.isReady
                                                    ? Colors.green.shade800
                                                    : null,
                                            label: state.player.isReady
                                                ? 'Confirmado'
                                                : 'Confirmar',
                                            onPressed: () {
                                              final player =
                                                  state.player.copyWith(
                                                isReady: !state.player.isReady,
                                              );
                                              riftStore.updatePlayer(player);
                                            },
                                          ),
                                          FMMButton(
                                            label: 'View Match',
                                            onPressed: hasMatch
                                                ? () {
                                                    Routefly.push('./match');
                                                  }
                                                : null,
                                          ),
                                          if (isOwner)
                                            FMMButton(
                                              label: 'Match!',
                                              onPressed: canCreateMatch
                                                  ? riftStore.match
                                                  : null,
                                            ),
                                          FMMButton(
                                            onPressed: () async {
                                              await Clipboard.setData(
                                                ClipboardData(
                                                  text:
                                                      'https://flutterandomatchmaker.web.app${Routefly.uri.path}',
                                                ),
                                              );
                                            },
                                            label: 'Copiar link',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.white,
                          ),
                          Flexible(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0XFF1D1B20),
                                  ),
                                  padding: const EdgeInsets.all(48),
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 7 / 2,
                                      crossAxisCount:
                                          constraints.maxWidth < 450 ? 1 : 2,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemCount: players.length,
                                    itemBuilder: (context, index) {
                                      final player = players[index];
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: player.isReady
                                                ? Colors.green
                                                : Colors.grey.shade600,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            player.name,
                                            maxLines: constraints.maxWidth <
                                                            520 &&
                                                        constraints.maxWidth >
                                                            450 ||
                                                    constraints.maxWidth < 300
                                                ? 1
                                                : 2,
                                          ),

                                          trailing: CircleAvatar(
                                            radius: constraints.maxWidth < 650
                                                ? 15
                                                : 20,
                                            backgroundColor: Colors.transparent,
                                            child: player.role.icon,
                                          ),
                                          // trailing: _removeButton(state, player),
                                          leading: player.isReady
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                )
                                              : const Icon(
                                                  Icons.access_alarm_sharp,
                                                  color: Colors.grey,
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget? _removeButton(RiftState state, Player player) {
    final isOwner = state.player.id == state.room.hostID;
    final isLocalPlayer = player.id == state.player.id;

    if (!isOwner || isLocalPlayer) {
      return null;
    }

    return IconButton(
      onPressed: () {
        riftStore.kickPlayer(player);
      },
      icon: const Icon(
        Icons.delete_forever_outlined,
      ),
    );
  }
}
