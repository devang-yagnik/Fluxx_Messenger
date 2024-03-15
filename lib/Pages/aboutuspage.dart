import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 1500,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 89, 0),
                  Color.fromARGB(255, 50, 120, 255),
                  Color.fromARGB(255, 190, 68, 255),
                ],
                stops: [0.45, 0.75, 0.93],
                begin: AlignmentDirectional(-1, 0.98),
                end: AlignmentDirectional(1, -0.98),
              ),
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0x00FFFFFF), Colors.white],
                  stops: [0, 0, 0.85],
                  begin: AlignmentDirectional(0, -1),
                  end: AlignmentDirectional(0, 1),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              child: Column(
                children: [
                  AppBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 20,
                    leading: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'About Us',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 24),
                        ),
                      ],
                    ),
                    centerTitle: false,
                    toolbarHeight: 70,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 20, right: 20, bottom: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Team',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 25),
                            ),
                            const SizedBox(height: 20),
                            _buildTeamMember(
                              'Dhaval Vala',
                              'Developer',
                              'assets/images/dhaval_vala.jpg',
                              'https://www.linkedin.com/in/dhaval-vala/',
                            ),
                            const SizedBox(height: 20),
                            _buildTeamMember(
                              'Devang Yagnik',
                              'Developer',
                              'assets/images/devang_yagnik.jpg',
                              'https://www.linkedin.com/in/devang-yagnik/',
                            ),
                            const SizedBox(height: 20),
                            _buildTeamMember(
                              'Pranav Thakwani',
                              'Developer',
                              'assets/images/pranav_thakwani.jpg',
                              'https://www.linkedin.com/in/pranav-thakwani/',
                            ),
                            const SizedBox(height: 20),
                            _buildTeamMember(
                              'Prof. Sweta Khatana',
                              'Guide',
                              'assets/images/sweta_khatana.jpg',
                              'https://www.linkedin.com/in/sweta-khatana-8a5482204/',
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              'From',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 25),
                            ),
                            const SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/marwadi_university.jpg',
                                height: 120, // Adjust the height as needed
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 45),
                              child: Text(
                                'Marwadi University, Rajkot, India 360003',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
      String name, String profession, String imagePath, String linkedInUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 133.33,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                profession,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  // Redirect to LinkedIn page
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.link,
                      color: Colors.blue,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'LinkedIn',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
