import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/core/values/constants.dart';
import 'package:TrailApp/core/values/keys.dart';
import 'package:TrailApp/cubit/settings_logic/settings_cubit.dart';
import 'package:TrailApp/routes/settings_navigation.dart';
import 'package:TrailApp/views/widgets/card_title.dart';
import 'package:TrailApp/views/widgets/list_button.dart';
import 'package:TrailApp/views/widgets/page_title.dart';
import 'package:TrailApp/views/widgets/rounded_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsCubit()..init(),
        ),
      ],
      child: CupertinoPageScaffold(
        backgroundColor: Color(0xFF14162D),
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
            children: const [
              _Title(),
              _GeneralCard(),
              _AboutCardTitle(),
              _AboutCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageTitle(title: 'Settings');
  }
}

class _GeneralCard extends StatelessWidget {
  const _GeneralCard({Key? key}) : super(key: key);

  void _changeNotificationState(BuildContext context, bool newValue) {
    final cubit = context.read<SettingsCubit>();
    final pomodoroTimer = cubit.state.pomodoroTimer;

    cubit.changePomodoroTimer(pomodoroTimer.copyWith(
      notify: newValue,
    ));
  }

  void _notificationSamplePickerPage(BuildContext context, String sampleKey) {
    Navigator.of(context).pushNamed(
      SettingsNavigationRoutes.notificationSamplePicker,
      arguments: {
        'sampleKey': sampleKey,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    const double itemHeight = 45;

    return RoundedCard(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      child: Column(
        children: [
          ListButton.withTrailingChevronIcon(
            iconData: CupertinoIcons.alarm,
            title: 'Timer settings',
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(SettingsNavigationRoutes.timerSettings);
            },
            height: itemHeight,
          ),
          ListButton.withTrailingChevronIcon(
            iconData: CupertinoIcons.music_note_2,
            title: 'Sound of break end',
            onPressed: () =>
                _notificationSamplePickerPage(context, kBreakEndKey),
            height: itemHeight,
          ),
          ListButton.withTrailingChevronIcon(
            iconData: CupertinoIcons.music_note_2,
            title: 'Sound of work end',
            onPressed: () =>
                _notificationSamplePickerPage(context, kWorkEndKey),
            height: itemHeight,
          ),
          ListButton.withTrailingSwitch(
            context: context,
            iconData: CupertinoIcons.bell,
            title: 'Notifications',
            value: cubit.state.pomodoroTimer.notify,
            onPressed: (value) {
              _changeNotificationState(context, value);
            },
            height: itemHeight,
          ),
        ],
      ),
    );
  }
}

class _AboutCardTitle extends StatelessWidget {
  const _AboutCardTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CardTitle(title: 'About Us');
  }
}
class _AboutCard extends StatelessWidget {
  const _AboutCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     const double itemHeight = 45;

    return RoundedCard(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      child: Column(
        children: [
          ListButton.withTrailingChevronIcon(
            iconData:Icons.library_books_outlined,
            title: 'What\'s up',
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(SettingsNavigationRoutes.introViewer);
            },
            height: itemHeight,
          ),
          ListButton.withTrailingChevronIcon(
              iconData:Icons.live_help_outlined,
              title: 'Help and Feedback',
              onPressed: _launchEmail,
              height: itemHeight,
          ),
          ListButton.withTrailingChevronIcon(
              iconData:Icons.logo_dev_rounded,
              title: 'GitHub',
              onPressed: _launchUrl,
              height: itemHeight,
          )
        ],
      ),
    );
  }
  void _launchEmail() async {
    final Uri _emailUri= Uri(scheme: 'mailto',path: 'umerbinshah2001@gmail.com');
    launchUrl(_emailUri);
  }
  void _launchUrl() async {
    final Uri _url = Uri.parse('https://github.com/SpaceCodr/TrailBloc2');
    if (!await launchUrl(_url)) {
      throw 'Could not launch$_url';
    }
  }
}
