export type Roadmap = {
  id: string;
  number: string;
  title: string;
  category: string;
  description: string;
  technologies: string[];
  skills: string[];
  difficulty: string;
  durationWeeks: number;
  opportunities: string[];
  prerequisites: string[];
  projects: string[];
  stages: { title: string; topics: string[] }[];
  icon: string;
};

export type RoadPreferences = {
  level: string;
  dailyTime: string;
  goal: string;
};
