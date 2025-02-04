// ignore_for_file: lines_longer_than_80_chars

import 'package:in_memory_headlines_client/in_memory_headlines_client.dart';

/// Mocked headlines data
final List<Headline> headlines = [
  Headline(
    id: 'headline_1',
    title: 'Breaking News: Market Hits Record Highs',
    content:
        'The stock market reached new record highs today, driven by strong earnings reports and positive economic data.',
    publishedBy: const Source(
      id: 'source_1',
      name: 'Financial Times',
      description: 'Leading global business publication',
      url: 'https://www.ft.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'GB',
        name: 'United Kingdom',
        flagUrl: 'https://www.ft.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.ft.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    happenedIn: const Country(
      code: 'US',
      name: 'United States',
      flagUrl: 'https://www.ft.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_2',
    title: 'Tech Giants Announce New Innovations',
    content:
        'Several tech giants announced new innovations at the annual tech conference, showcasing the latest advancements in AI and robotics.',
    publishedBy: const Source(
      id: 'source_2',
      name: 'TechCrunch',
      description: 'Technology news and analysis',
      url: 'https://www.techcrunch.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'US',
        name: 'United States',
        flagUrl: 'https://www.techcrunch.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.techcrunch.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    happenedIn: const Country(
      code: 'US',
      name: 'United States',
      flagUrl: 'https://www.techcrunch.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_3',
    title: 'Health Officials Warn of New Virus Outbreak',
    content:
        'Health officials have issued a warning about a new virus outbreak, urging the public to take precautions and stay informed.',
    publishedBy: const Source(
      id: 'source_3',
      name: 'BBC News',
      description: 'Trusted global news source',
      url: 'https://www.bbc.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'GB',
        name: 'United Kingdom',
        flagUrl: 'https://www.bbc.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.bbc.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 3)),
    happenedIn: const Country(
      code: 'CN',
      name: 'China',
      flagUrl: 'https://www.bbc.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_4',
    title: 'Sports Update: Championship Results',
    content:
        'The championship games concluded with thrilling results, as teams battled for the top spot in their respective leagues.',
    publishedBy: const Source(
      id: 'source_4',
      name: 'ESPN',
      description: 'Worldwide leader in sports',
      url: 'https://www.espn.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'US',
        name: 'United States',
        flagUrl: 'https://www.espn.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.espn.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 4)),
    happenedIn: const Country(
      code: 'US',
      name: 'United States',
      flagUrl: 'https://www.espn.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_5',
    title: 'Entertainment News: Award Show Highlights',
    content:
        'The annual award show celebrated the best in entertainment, with memorable performances and emotional acceptance speeches.',
    publishedBy: const Source(
      id: 'source_5',
      name: 'Variety',
      description: 'Entertainment industry news',
      url: 'https://www.variety.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'US',
        name: 'United States',
        flagUrl: 'https://www.variety.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.variety.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 5)),
    happenedIn: const Country(
      code: 'US',
      name: 'United States',
      flagUrl: 'https://www.variety.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_6',
    title: 'Climate Change: New Report Released',
    content:
        'A new report on climate change highlights the urgent need for action to mitigate the effects of global warming.',
    publishedBy: const Source(
      id: 'source_6',
      name: 'National Geographic',
      description: 'Exploring the world and all that is in it',
      url: 'https://www.nationalgeographic.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'US',
        name: 'United States',
        flagUrl: 'https://www.nationalgeographic.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.nationalgeographic.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 6)),
    happenedIn: const Country(
      code: 'US',
      name: 'United States',
      flagUrl: 'https://www.nationalgeographic.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_7',
    title: 'Economic Outlook: Experts Weigh In',
    content:
        'Economic experts provide their outlook for the coming year, discussing potential challenges and opportunities.',
    publishedBy: const Source(
      id: 'source_7',
      name: 'The Economist',
      description: 'Authoritative global news and analysis',
      url: 'https://www.economist.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'GB',
        name: 'United Kingdom',
        flagUrl: 'https://www.economist.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.economist.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 7)),
    happenedIn: const Country(
      code: 'US',
      name: 'United States',
      flagUrl: 'https://www.economist.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_8',
    title: 'Travel Advisory: New Guidelines Issued',
    content:
        'New travel guidelines have been issued in response to the ongoing pandemic, affecting international travel plans.',
    publishedBy: const Source(
      id: 'source_8',
      name: 'CNN Travel',
      description: 'Travel news and tips',
      url: 'https://www.cnn.com/travel',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'US',
        name: 'United States',
        flagUrl: 'https://www.cnn.com/travel/flag.png',
      ),
    ),
    imageUrl: 'https://www.cnn.com/travel/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 8)),
    happenedIn: const Country(
      code: 'US',
      name: 'United States',
      flagUrl: 'https://www.cnn.com/travel/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_9',
    title: 'Education Reform: New Policies Announced',
    content:
        'The government has announced new policies aimed at reforming the education system and improving student outcomes.',
    publishedBy: const Source(
      id: 'source_9',
      name: 'The Guardian',
      description: 'Independent journalism since 1821',
      url: 'https://www.theguardian.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'GB',
        name: 'United Kingdom',
        flagUrl: 'https://www.theguardian.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.theguardian.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 9)),
    happenedIn: const Country(
      code: 'GB',
      name: 'United Kingdom',
      flagUrl: 'https://www.theguardian.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_10',
    title: 'Science Breakthrough: New Discovery',
    content:
        'Scientists have made a groundbreaking discovery that could change our understanding of the universe.',
    publishedBy: const Source(
      id: 'source_10',
      name: 'Scientific American',
      description: 'Advancing science and technology',
      url: 'https://www.scientificamerican.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'US',
        name: 'United States',
        flagUrl: 'https://www.scientificamerican.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.scientificamerican.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 10)),
    happenedIn: const Country(
      code: 'US',
      name: 'United States',
      flagUrl: 'https://www.scientificamerican.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
  Headline(
    id: 'headline_11',
    title: 'War Breakthrough: New Warzone',
    content:
        'Warriors have made a groundbreaking discovery that could change our understanding of the universe.',
    publishedBy: const Source(
      id: 'source_11',
      name: 'Scientific North Korean',
      description: 'Advancing science and technology',
      url: 'https://www.scientificamerican.com',
      language: Language(code: 'en', name: 'English'),
      country: Country(
        code: 'NK',
        name: 'North Korea',
        flagUrl: 'https://www.scientificamerican.com/flag.png',
      ),
    ),
    imageUrl: 'https://www.scientificamerican.com/image.png',
    publishedAt: DateTime.now().subtract(const Duration(days: 10)),
    happenedIn: const Country(
      code: 'NK',
      name: 'North Korea',
      flagUrl: 'https://www.scientificamerican.com/flag.png',
    ),
    language: const Language(code: 'en', name: 'English'),
  ),
];
