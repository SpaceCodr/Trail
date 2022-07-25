import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:TrailApp/core/extensions/color.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/core/values/constants.dart';
import 'package:TrailApp/core/values/keys.dart';
import 'package:TrailApp/cubit/project_logic/project_cubit.dart';
import 'package:TrailApp/models/project.dart';
import 'package:TrailApp/routes/main_navigation.dart';
import 'package:TrailApp/views/widgets/action_button.dart';
import 'package:TrailApp/views/widgets/card_title.dart';
import 'package:TrailApp/views/widgets/list_button.dart';
import 'package:TrailApp/views/widgets/page_title.dart';
import 'package:TrailApp/views/widgets/rounded_card.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectCubit()..init(),
      child: CupertinoPageScaffold(
        backgroundColor: Color(0xFF14162D),
        child: SafeArea(
          child: BlocBuilder<ProjectCubit, ProjectState>(
            builder: (context, state) {
              if (state is ProjectLoaded) {
                return const _Body();
              }

              return const _LoadingScreen();
            },
          ),
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      shrinkWrap: true,
      children: const [
        _Title(),
        _MainProjectList(),
        _ProjectList(),
        _ProjectAddButton(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageTitle(title: 'My Tasks');
  }
}

class _MainProjectList extends StatelessWidget {
  const _MainProjectList({Key? key}) : super(key: key);

  void _openDetailPage(BuildContext context, Project project) async {
    final box = Hive.box<Project>(kMainProjectBox);
    final projects =
        (context.read<ProjectCubit>().state as ProjectLoaded).mainProjects;
    final projectKey = box.keyAt(projects.indexOf(project)) as int;

    Navigator.of(context).pushNamed(
      MainNavigationRoutes.projectDetail,
      arguments: {
        'boxName': kMainProjectBox,
        'project': project,
        'projectKey': projectKey,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.arrow_downward_rounded,
      Icons.today,
      Icons.calendar_month_rounded,
      CupertinoIcons.infinite,
    ];

    final state = context.watch<ProjectCubit>().state;
    final projects = (state as ProjectLoaded).mainProjects;

    return RoundedCard(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
      child: Column(
        children: List.generate(
          projects.length,
          (index) {
            int? completedTasksCount = context
                .read<ProjectCubit>()
                .getCompletedTaskCount(projects[index]);
            return ListButton.withLeadingIcon(
              iconData: icons[index],
              iconSize: 20,
              iconColor: HexColor.fromHex(projects[index].color),
              title: projects[index].title,
              onPressed: () => _openDetailPage(context, projects[index]),
              trailing: completedTasksCount != null
                  ? Text('$completedTasksCount')
                  : const SizedBox(),
            );
          },
        ),
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList({Key? key}) : super(key: key);

  void _openDetailPage(BuildContext context, Project project) async {
    final box = await Hive.openBox<Project>(kProjectBox);
    final projects =
        (context.read<ProjectCubit>().state as ProjectLoaded).projects;
    final projectKey = box.keyAt(projects.indexOf(project)) as int;

    Navigator.of(context).pushNamed(
      MainNavigationRoutes.projectDetail,
      arguments: {
        'boxName': kProjectBox,
        'project': project,
        'projectKey': projectKey,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProjectCubit>().state;
    final projects = (state as ProjectLoaded).projects;

    return projects.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardTitle(title: 'Projects'),
              RoundedCard(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultMargin),
                child: Column(
                  children: List.generate(
                    projects.length,
                    (index) {
                      int? completedTasksCount = context
                          .read<ProjectCubit>()
                          .getCompletedTaskCount(projects[index]);

                      return ListButton.withLeadingIcon(
                        iconData: CupertinoIcons.circle_fill,
                        iconSize: 18,
                        iconColor: HexColor.fromHex(projects[index].color),
                        title: projects[index].title,
                        onPressed: () =>
                            _openDetailPage(context, projects[index]),
                        trailing: completedTasksCount != null
                            ? Text('$completedTasksCount')
                            : const SizedBox(),
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}

class _ProjectAddButton extends StatelessWidget {
  const _ProjectAddButton({Key? key}) : super(key: key);

  void _openForm(BuildContext context) async {
    Navigator.of(context).pushNamed(
      MainNavigationRoutes.projectForm,
      arguments: {
        'boxName': kProjectBox,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      color: CupertinoColors.black.withOpacity(0),
      onPressed: () => _openForm(context),
      childAlignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.add,
            color: kBlueColor,
          ),
          const SizedBox(width: kDefaultMargin / 2),
          Text(
            'Add Project',
            style: TextStyle(
              fontSize: 18,
              color: kBlueColor,
            ),
          ),
        ],
      ),
    );
  }
}
