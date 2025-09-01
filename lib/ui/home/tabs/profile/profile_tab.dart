import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_states.dart';
import 'package:movies_app/ui/home/tabs/profile/bloc/profile_view_model.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_resources.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  ProfileViewModel profileViewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    profileViewModel.getProfile();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: SafeArea(
        child: Column(
          children: [
            // user info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // user avatar and name
                  BlocBuilder<ProfileViewModel, ProfileStates>(
                    bloc: profileViewModel,
                    builder: (context, state) {
                      if (state is ProfileErrorState) {
                        return Text(
                          state.errorMessage,
                          style: AppStyles.bold20white,
                        );
                      }
                      if (state is ProfileSuccessState) {
                        return Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  AppResources.avatarList[state.user.avaterId ?? 0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(state.user.name ?? '', style: AppStyles.bold20white),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.yellow,
                        ),
                      );
                    },
                  ),

                  // WishList and History
                  Column(
                    children: [
                      Text("12", style: AppStyles.bold36white),
                      Text("WishList", style: AppStyles.bold24white),
                    ],
                  ),
                  Column(
                    children: [
                      Text("20", style: AppStyles.bold36white),
                      Text("History", style: AppStyles.bold24white),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),

            // Edit Profile and Exit buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.updateProfile);
                      },
                      text: "Edit Profile",
                      textStyle: AppStyles.regular20black,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      onPressed: () async{
                        final SharedPreferences pref = await SharedPreferences.getInstance();
                        await pref.remove('token');
                        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (result) => false);
                      },
                      text: "Exit",
                      hasIcon: true,
                      iconWidget: const Icon(
                        Icons.exit_to_app,
                        color: AppColors.white,
                      ),
                      backgroundColor: AppColors.red,
                      borderColorSide: AppColors.red,
                      textStyle: AppStyles.regular20white,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
            // Tab Bar for WatchList and History using a manual TabController
            TabBar(
              dividerHeight: 0,
              indicatorColor: AppColors.yellow,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              tabs: [
                Tab(
                  text: "WatchList",
                  icon: Icon(
                    Icons.list,
                    size: height * 0.04,
                    color: AppColors.yellow,
                  ),
                ),
                Tab(
                  text: "History",
                  icon: Icon(
                    Icons.folder,
                    color: AppColors.yellow,
                    size: height * 0.04,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    decoration: BoxDecoration(color: AppColors.black),
                    child: Center(child: Image.asset(AppAssets.emptyListIcon)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    decoration: BoxDecoration(color: AppColors.black),
                    child: Center(child: Image.asset(AppAssets.emptyListIcon)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
