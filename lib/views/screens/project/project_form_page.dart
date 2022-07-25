import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TrailApp/components/popup_modal.dart';
import 'package:TrailApp/core/values/colors.dart';
import 'package:TrailApp/core/values/constants.dart';
import 'package:TrailApp/cubit/project_form_logic/project_form_cubit.dart';
import 'package:TrailApp/models/project.dart';
import 'package:TrailApp/routes/main_navigation.dart';
import 'package:TrailApp/views/widgets/action_button.dart';
import 'package:TrailApp/views/widgets/back_button.dart';
import 'package:TrailApp/views/widgets/card_title.dart';
import 'package:TrailApp/views/widgets/page_title.dart';
import 'package:TrailApp/views/widgets/rounded_card.dart';

class ProjectFormPage extends StatelessWidget {
  const ProjectFormPage({
    Key? key,
    required this.boxName,
    this.project,
    this.projectKey,
  }) : super(key: key);

  final String boxName;
  final Project? project;
  final int? projectKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectformCubit>(
      create: (context) => ProjectformCubit(
        boxName: boxName,
        project: project,
        projectKey: projectKey,
      ),
      child: CupertinoPageScaffold(
        backgroundColor: Color(0xFF14162D),
        child: SafeArea(
          child: Stack(
            children: const [
              _Body(),
              _ActionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        _Header(),
        _Title(),
        _ProjectNameField(),
        _CardTitle(),
        _ProjectColorPicker(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Back_Button(),
        _DeleteProjectButton(),
      ],
    );
  }
}

class _DeleteProjectButton extends StatelessWidget {
  const _DeleteProjectButton({Key? key}) : super(key: key);

  void _showModal(BuildContext context) {
    final cubit = context.read<ProjectformCubit>();

    showPopupModal(
      context: context,
      title: 'Are you sure delete project?',
      onConiform: () async {
        await cubit.deleteProject();
        Navigator.of(context)
            .pushReplacementNamed(MainNavigationRoutes.projects);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = context.read<ProjectformCubit>().state.isEditMode;
    return isEditMode
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.trash_circle,
              color: Colors.redAccent,
              size: 25,
            ),
            onPressed: () => _showModal(context),
          )
        : const SizedBox();
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectformCubit>();

    return PageTitle.withHorizontalMargin(
        title:
            cubit.state.isEditMode ? cubit.state.projectTitle : 'New Project');
  }
}

class _ProjectNameField extends StatelessWidget {
  const _ProjectNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color =
        context.select((ProjectformCubit cubit) => cubit.state.projectColor);

    return RoundedCard.withHorizontalMargin(
      child: CupertinoTextField(
        prefix: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(
            CupertinoIcons.circle_fill,
            color: color,
            size: 20,
          ),
        ),
        padding: EdgeInsets.zero,
        placeholderStyle: const TextStyle(
          fontFamily: 'Titlefont5',
          fontSize: 18,
          color: Colors.grey,
        ),
        style: const TextStyle(
          fontFamily: 'Titlefont5',
          fontSize: 18,
          color: kTextColor,
        ),
        placeholder: 'Project name',
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        controller: TextEditingController(
          text: context.read<ProjectformCubit>().state.projectTitle,
        ),
        onChanged: (value) {
          final cubit = context.read<ProjectformCubit>();
          cubit.changeState(
            cubit.state.copyWith(
              projectTitle: value,
            ),
          );
        },
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardTitle.withHorizontalMargin(title: 'Colors');
  }
}

class _ProjectColorPicker extends StatelessWidget {
  const _ProjectColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color =
        context.select((ProjectformCubit cubit) => cubit.state.projectColor);

    return RoundedCard.withHorizontalMargin(
      child: GridView.count(
        crossAxisCount: 6,
        shrinkWrap: true,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: List.generate(
          projectColors.length,
          (index) => _ColoredCircleButton(
            color: projectColors[index],
            onPick: (value) {
              final cubit = context.read<ProjectformCubit>();
              cubit.changeState(
                cubit.state.copyWith(
                  projectColor: value,
                ),
              );
            },
            isSelected: index == projectColors.indexOf(color),
          ),
        ),
      ),
    );
  }
}

class _ColoredCircleButton extends StatelessWidget {
  const _ColoredCircleButton({
    Key? key,
    required this.color,
    required this.onPick,
    required this.isSelected,
  }) : super(key: key);

  final Color color;
  final void Function(Color) onPick;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: isSelected
            ? const Icon(
                CupertinoIcons.checkmark_alt,
                color: kTextColor,
                size: 25,
              )
            : const SizedBox(),
      ),
      onPressed: () => onPick.call(color),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectformCubit>();
    final isEditMode = cubit.state.isEditMode;
    final action = isEditMode ? cubit.tryUpdateProject : cubit.tryAddProject;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ActionButton.withChildText(
        context: context,
        onPressed: () async {
          final canBack = await action.call();

          if (canBack) {
            Navigator.of(context).pop();
          }
        },
        color: kOrangeColor,
        title: isEditMode ? 'Save' : 'Add Project',
        margin: const EdgeInsets.all(kDefaultMargin),
      ),
    );
  }
}
