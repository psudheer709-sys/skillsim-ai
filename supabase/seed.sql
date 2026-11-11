-- Generated from src/lib/roadmaps.ts and src/lib/data.ts. Safe to rerun.
begin;
insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values ('python-dsa','Python + DSA','Build strong Python foundations and learn to solve problems with confidence using core data structures and algorithms.','Programming and DSA','Beginner to Advanced',32,array['Python Developer', 'Software Engineer', 'Backend Developer']::text[],array['Python', 'Data Structures', 'Algorithms', 'Python Fundamentals', 'Variables and Data Types', 'Conditional Statements', 'Loops', 'Functions', 'Lists, Tuples, Sets and Dictionaries', 'Object-Oriented Programming']::text[],array[]::text[],true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Python Basics','Learn python basics through Python Fundamentals and related practice.',1 from public.roadmaps where roadmap_code='python-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Python Basics, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Python Basics.','Apply Python Basics concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Python Basics within the Python + DSA career roadmap.','exercise','Practise Python Basics by creating a small example and explaining your approach.','challenge','Extend your Python Basics example to handle a new constraint.','roadmapCode','python-dsa','technologies',array['Python', 'Data Structures', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=1
cross join unnest(array['Python Fundamentals', 'Variables and Data Types', 'Conditional Statements', 'Loops']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='python-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Intermediate Python','Learn intermediate python through Functions and related practice.',2 from public.roadmaps where roadmap_code='python-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Intermediate Python, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Intermediate Python.','Apply Intermediate Python concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Intermediate Python within the Python + DSA career roadmap.','exercise','Practise Intermediate Python by creating a small example and explaining your approach.','challenge','Extend your Intermediate Python example to handle a new constraint.','roadmapCode','python-dsa','technologies',array['Python', 'Data Structures', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=2
cross join unnest(array['Functions', 'Lists, Tuples, Sets and Dictionaries']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='python-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Object-Oriented Programming','Learn object-oriented programming through Object-Oriented Programming and related practice.',3 from public.roadmaps where roadmap_code='python-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Object-Oriented Programming, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Object-Oriented Programming.','Apply Object-Oriented Programming concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Object-Oriented Programming within the Python + DSA career roadmap.','exercise','Practise Object-Oriented Programming by creating a small example and explaining your approach.','challenge','Extend your Object-Oriented Programming example to handle a new constraint.','roadmapCode','python-dsa','technologies',array['Python', 'Data Structures', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=3
cross join unnest(array['Object-Oriented Programming']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='python-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'DSA Fundamentals','Learn dsa fundamentals through Recursion and related practice.',4 from public.roadmaps where roadmap_code='python-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in DSA Fundamentals, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of DSA Fundamentals.','Apply DSA Fundamentals concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn DSA Fundamentals within the Python + DSA career roadmap.','exercise','Practise DSA Fundamentals by creating a small example and explaining your approach.','challenge','Extend your DSA Fundamentals example to handle a new constraint.','roadmapCode','python-dsa','technologies',array['Python', 'Data Structures', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=4
cross join unnest(array['Recursion', 'DSA Fundamentals', 'Arrays and Strings', 'Searching and Sorting', 'Linked Lists', 'Stacks and Queues', 'Trees and Graphs', 'Hashing']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='python-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Advanced DSA','Learn advanced dsa through Dynamic Programming and related practice.',5 from public.roadmaps where roadmap_code='python-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Advanced DSA, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Advanced DSA.','Apply Advanced DSA concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Advanced DSA within the Python + DSA career roadmap.','exercise','Practise Advanced DSA by creating a small example and explaining your approach.','challenge','Extend your Advanced DSA example to handle a new constraint.','roadmapCode','python-dsa','technologies',array['Python', 'Data Structures', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=5
cross join unnest(array['Dynamic Programming']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='python-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Problem Solving','Learn problem solving through Problem Solving Practice and related practice.',6 from public.roadmaps where roadmap_code='python-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Problem Solving, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Problem Solving.','Apply Problem Solving concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Problem Solving within the Python + DSA career roadmap.','exercise','Practise Problem Solving by creating a small example and explaining your approach.','challenge','Extend your Problem Solving example to handle a new constraint.','roadmapCode','python-dsa','technologies',array['Python', 'Data Structures', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=6
cross join unnest(array['Problem Solving Practice']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='python-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Projects','Learn projects through Python Projects and related practice.',7 from public.roadmaps where roadmap_code='python-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Projects, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Projects.','Apply Projects concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Projects within the Python + DSA career roadmap.','exercise','Practise Projects by creating a small example and explaining your approach.','challenge','Extend your Projects example to handle a new constraint.','roadmapCode','python-dsa','technologies',array['Python', 'Data Structures', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=7
cross join unnest(array['Python Projects']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='python-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Interview Preparation','Learn interview preparation through Interview Preparation and related practice.',8 from public.roadmaps where roadmap_code='python-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Interview Preparation, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Interview Preparation.','Apply Interview Preparation concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Interview Preparation within the Python + DSA career roadmap.','exercise','Practise Interview Preparation by creating a small example and explaining your approach.','challenge','Extend your Interview Preparation example to handle a new constraint.','roadmapCode','python-dsa','technologies',array['Python', 'Data Structures', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=8
cross join unnest(array['Interview Preparation']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='python-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values ('cpp-dsa','C++ + DSA','Develop efficient C++ programming skills and practise the data structures used in technical interviews and competitive programming.','Programming and DSA','Beginner to Advanced',34,array['C++ Developer', 'Software Engineer', 'Competitive Programmer']::text[],array['C++', 'STL', 'Algorithms', 'C++ Fundamentals', 'Variables and Data Types', 'Operators and Conditions', 'Loops', 'Functions', 'Pointers and References', 'Arrays and Strings']::text[],array[]::text[],true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'C++ foundations','Learn c++ foundations through C++ Fundamentals and related practice.',1 from public.roadmaps where roadmap_code='cpp-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in C++ foundations, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of C++ foundations.','Apply C++ foundations concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn C++ foundations within the C++ + DSA career roadmap.','exercise','Practise C++ foundations by creating a small example and explaining your approach.','challenge','Extend your C++ foundations example to handle a new constraint.','roadmapCode','cpp-dsa','technologies',array['C++', 'STL', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=1
cross join unnest(array['C++ Fundamentals', 'Variables and Data Types', 'Operators and Conditions']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cpp-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Language essentials','Learn language essentials through Loops and related practice.',2 from public.roadmaps where roadmap_code='cpp-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Language essentials, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Language essentials.','Apply Language essentials concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Language essentials within the C++ + DSA career roadmap.','exercise','Practise Language essentials by creating a small example and explaining your approach.','challenge','Extend your Language essentials example to handle a new constraint.','roadmapCode','cpp-dsa','technologies',array['C++', 'STL', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=2
cross join unnest(array['Loops', 'Functions', 'Pointers and References']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cpp-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'OOP and STL','Learn oop and stl through Arrays and Strings and related practice.',3 from public.roadmaps where roadmap_code='cpp-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in OOP and STL, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of OOP and STL.','Apply OOP and STL concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn OOP and STL within the C++ + DSA career roadmap.','exercise','Practise OOP and STL by creating a small example and explaining your approach.','challenge','Extend your OOP and STL example to handle a new constraint.','roadmapCode','cpp-dsa','technologies',array['C++', 'STL', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=3
cross join unnest(array['Arrays and Strings', 'Object-Oriented Programming', 'Standard Template Library (STL)']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cpp-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Algorithmic thinking','Learn algorithmic thinking through Recursion and related practice.',4 from public.roadmaps where roadmap_code='cpp-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Algorithmic thinking, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Algorithmic thinking.','Apply Algorithmic thinking concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Algorithmic thinking within the C++ + DSA career roadmap.','exercise','Practise Algorithmic thinking by creating a small example and explaining your approach.','challenge','Extend your Algorithmic thinking example to handle a new constraint.','roadmapCode','cpp-dsa','technologies',array['C++', 'STL', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=4
cross join unnest(array['Recursion', 'Searching and Sorting', 'Linked Lists']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cpp-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Core data structures','Learn core data structures through Stacks and Queues and related practice.',5 from public.roadmaps where roadmap_code='cpp-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Core data structures, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Core data structures.','Apply Core data structures concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Core data structures within the C++ + DSA career roadmap.','exercise','Practise Core data structures by creating a small example and explaining your approach.','challenge','Extend your Core data structures example to handle a new constraint.','roadmapCode','cpp-dsa','technologies',array['C++', 'STL', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=5
cross join unnest(array['Stacks and Queues', 'Trees and Graphs', 'Hashing']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cpp-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Advanced problem solving','Learn advanced problem solving through Dynamic Programming and related practice.',6 from public.roadmaps where roadmap_code='cpp-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Advanced problem solving, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Advanced problem solving.','Apply Advanced problem solving concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Advanced problem solving within the C++ + DSA career roadmap.','exercise','Practise Advanced problem solving by creating a small example and explaining your approach.','challenge','Extend your Advanced problem solving example to handle a new constraint.','roadmapCode','cpp-dsa','technologies',array['C++', 'STL', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=6
cross join unnest(array['Dynamic Programming', 'Competitive Programming Practice', 'C++ Projects']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cpp-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Projects and interviews','Learn projects and interviews through Interview Preparation and related practice.',7 from public.roadmaps where roadmap_code='cpp-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Projects and interviews, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Projects and interviews.','Apply Projects and interviews concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Projects and interviews within the C++ + DSA career roadmap.','exercise','Practise Projects and interviews by creating a small example and explaining your approach.','challenge','Extend your Projects and interviews example to handle a new constraint.','roadmapCode','cpp-dsa','technologies',array['C++', 'STL', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=7
cross join unnest(array['Interview Preparation']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cpp-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values ('java-dsa','Java + DSA','Learn modern Java and apply it to problem solving, object-oriented design and interview-ready data structures.','Programming and DSA','Beginner to Advanced',30,array['Java Developer', 'Software Engineer', 'Android Developer']::text[],array['Java', 'Collections', 'Algorithms', 'Java Fundamentals', 'Variables and Data Types', 'Conditions and Loops', 'Methods', 'Arrays and Strings', 'Object-Oriented Programming', 'Exception Handling']::text[],array[]::text[],true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Java foundations','Learn java foundations through Java Fundamentals and related practice.',1 from public.roadmaps where roadmap_code='java-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Java foundations, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Java foundations.','Apply Java foundations concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Java foundations within the Java + DSA career roadmap.','exercise','Practise Java foundations by creating a small example and explaining your approach.','challenge','Extend your Java foundations example to handle a new constraint.','roadmapCode','java-dsa','technologies',array['Java', 'Collections', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=1
cross join unnest(array['Java Fundamentals', 'Variables and Data Types', 'Conditions and Loops']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='java-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Core language skills','Learn core language skills through Methods and related practice.',2 from public.roadmaps where roadmap_code='java-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Core language skills, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Core language skills.','Apply Core language skills concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Core language skills within the Java + DSA career roadmap.','exercise','Practise Core language skills by creating a small example and explaining your approach.','challenge','Extend your Core language skills example to handle a new constraint.','roadmapCode','java-dsa','technologies',array['Java', 'Collections', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=2
cross join unnest(array['Methods', 'Arrays and Strings', 'Object-Oriented Programming']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='java-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Object-oriented design','Learn object-oriented design through Exception Handling and related practice.',3 from public.roadmaps where roadmap_code='java-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Object-oriented design, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Object-oriented design.','Apply Object-oriented design concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Object-oriented design within the Java + DSA career roadmap.','exercise','Practise Object-oriented design by creating a small example and explaining your approach.','challenge','Extend your Object-oriented design example to handle a new constraint.','roadmapCode','java-dsa','technologies',array['Java', 'Collections', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=3
cross join unnest(array['Exception Handling', 'Collections Framework', 'Recursion']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='java-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Collections and algorithms','Learn collections and algorithms through Searching and Sorting and related practice.',4 from public.roadmaps where roadmap_code='java-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Collections and algorithms, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Collections and algorithms.','Apply Collections and algorithms concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Collections and algorithms within the Java + DSA career roadmap.','exercise','Practise Collections and algorithms by creating a small example and explaining your approach.','challenge','Extend your Collections and algorithms example to handle a new constraint.','roadmapCode','java-dsa','technologies',array['Java', 'Collections', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=4
cross join unnest(array['Searching and Sorting', 'Linked Lists', 'Stacks and Queues']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='java-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Data structures','Learn data structures through Trees and Graphs and related practice.',5 from public.roadmaps where roadmap_code='java-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Data structures, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Data structures.','Apply Data structures concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Data structures within the Java + DSA career roadmap.','exercise','Practise Data structures by creating a small example and explaining your approach.','challenge','Extend your Data structures example to handle a new constraint.','roadmapCode','java-dsa','technologies',array['Java', 'Collections', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=5
cross join unnest(array['Trees and Graphs', 'Hashing', 'Dynamic Programming']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='java-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Projects and interviews','Learn projects and interviews through Java Projects and related practice.',6 from public.roadmaps where roadmap_code='java-dsa'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Projects and interviews, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Projects and interviews.','Apply Projects and interviews concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Projects and interviews within the Java + DSA career roadmap.','exercise','Practise Projects and interviews by creating a small example and explaining your approach.','challenge','Extend your Projects and interviews example to handle a new constraint.','roadmapCode','java-dsa','technologies',array['Java', 'Collections', 'Algorithms']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=6
cross join unnest(array['Java Projects', 'Interview Preparation']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='java-dsa'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values ('full-stack','Full Stack Web Development','Create responsive web experiences and learn how frontend, server and database systems work together.','Web Development','Beginner to Advanced',36,array['Full Stack Developer', 'Frontend Developer', 'Web Application Engineer']::text[],array['HTML', 'CSS', 'JavaScript', 'React', 'Next.js', 'Node.js', 'PostgreSQL', 'HTML', 'CSS', 'JavaScript', 'Responsive Web Design', 'React', 'Next.js', 'Node.js']::text[],array[]::text[],true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Foundations','Learn foundations through HTML and related practice.',1 from public.roadmaps where roadmap_code='full-stack'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Foundations, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Foundations.','Apply Foundations concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Foundations within the Full Stack Web Development career roadmap.','exercise','Practise Foundations by creating a small example and explaining your approach.','challenge','Extend your Foundations example to handle a new constraint.','roadmapCode','full-stack','technologies',array['HTML', 'CSS', 'JavaScript', 'React', 'Next.js', 'Node.js', 'PostgreSQL']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=1
cross join unnest(array['HTML', 'CSS', 'JavaScript']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='full-stack'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Core skills','Learn core skills through Responsive Web Design and related practice.',2 from public.roadmaps where roadmap_code='full-stack'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Core skills, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Core skills.','Apply Core skills concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Core skills within the Full Stack Web Development career roadmap.','exercise','Practise Core skills by creating a small example and explaining your approach.','challenge','Extend your Core skills example to handle a new constraint.','roadmapCode','full-stack','technologies',array['HTML', 'CSS', 'JavaScript', 'React', 'Next.js', 'Node.js', 'PostgreSQL']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=2
cross join unnest(array['Responsive Web Design', 'React', 'Next.js']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='full-stack'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Applied practice','Learn applied practice through Node.js and related practice.',3 from public.roadmaps where roadmap_code='full-stack'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Applied practice, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Applied practice.','Apply Applied practice concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Applied practice within the Full Stack Web Development career roadmap.','exercise','Practise Applied practice by creating a small example and explaining your approach.','challenge','Extend your Applied practice example to handle a new constraint.','roadmapCode','full-stack','technologies',array['HTML', 'CSS', 'JavaScript', 'React', 'Next.js', 'Node.js', 'PostgreSQL']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=3
cross join unnest(array['Node.js', 'Express.js', 'REST APIs']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='full-stack'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Advanced concepts','Learn advanced concepts through Database Fundamentals and related practice.',4 from public.roadmaps where roadmap_code='full-stack'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Advanced concepts, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Advanced concepts.','Apply Advanced concepts concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Advanced concepts within the Full Stack Web Development career roadmap.','exercise','Practise Advanced concepts by creating a small example and explaining your approach.','challenge','Extend your Advanced concepts example to handle a new constraint.','roadmapCode','full-stack','technologies',array['HTML', 'CSS', 'JavaScript', 'React', 'Next.js', 'Node.js', 'PostgreSQL']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=4
cross join unnest(array['Database Fundamentals', 'PostgreSQL', 'Authentication']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='full-stack'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Build & demonstrate','Learn build & demonstrate through Git and GitHub and related practice.',5 from public.roadmaps where roadmap_code='full-stack'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Build & demonstrate, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Build & demonstrate.','Apply Build & demonstrate concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Build & demonstrate within the Full Stack Web Development career roadmap.','exercise','Practise Build & demonstrate by creating a small example and explaining your approach.','challenge','Extend your Build & demonstrate example to handle a new constraint.','roadmapCode','full-stack','technologies',array['HTML', 'CSS', 'JavaScript', 'React', 'Next.js', 'Node.js', 'PostgreSQL']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=5
cross join unnest(array['Git and GitHub', 'Full Stack Projects', 'Deployment']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='full-stack'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values ('ai-ml','AI and Machine Learning','Build the foundations to explore machine learning, neural networks and generative AI through practical projects.','Artificial Intelligence','Intermediate',38,array['AI/ML Engineer', 'Machine Learning Engineer', 'NLP Engineer']::text[],array['Python', 'NumPy', 'Pandas', 'scikit-learn', 'Neural Networks', 'Python Fundamentals', 'Mathematics for AI', 'NumPy', 'Pandas', 'Data Visualization', 'Statistics', 'Machine Learning Fundamentals']::text[],array['Basic programming and algebra']::text[],true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Foundations','Learn foundations through Python Fundamentals and related practice.',1 from public.roadmaps where roadmap_code='ai-ml'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Foundations, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Foundations.','Apply Foundations concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Foundations within the AI and Machine Learning career roadmap.','exercise','Practise Foundations by creating a small example and explaining your approach.','challenge','Extend your Foundations example to handle a new constraint.','roadmapCode','ai-ml','technologies',array['Python', 'NumPy', 'Pandas', 'scikit-learn', 'Neural Networks']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=1
cross join unnest(array['Python Fundamentals', 'Mathematics for AI', 'NumPy']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='ai-ml'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Core skills','Learn core skills through Pandas and related practice.',2 from public.roadmaps where roadmap_code='ai-ml'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Core skills, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Core skills.','Apply Core skills concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Core skills within the AI and Machine Learning career roadmap.','exercise','Practise Core skills by creating a small example and explaining your approach.','challenge','Extend your Core skills example to handle a new constraint.','roadmapCode','ai-ml','technologies',array['Python', 'NumPy', 'Pandas', 'scikit-learn', 'Neural Networks']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=2
cross join unnest(array['Pandas', 'Data Visualization', 'Statistics']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='ai-ml'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Applied practice','Learn applied practice through Machine Learning Fundamentals and related practice.',3 from public.roadmaps where roadmap_code='ai-ml'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Applied practice, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Applied practice.','Apply Applied practice concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Applied practice within the AI and Machine Learning career roadmap.','exercise','Practise Applied practice by creating a small example and explaining your approach.','challenge','Extend your Applied practice example to handle a new constraint.','roadmapCode','ai-ml','technologies',array['Python', 'NumPy', 'Pandas', 'scikit-learn', 'Neural Networks']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=3
cross join unnest(array['Machine Learning Fundamentals', 'Supervised Learning', 'Unsupervised Learning']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='ai-ml'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Advanced concepts','Learn advanced concepts through Model Evaluation and related practice.',4 from public.roadmaps where roadmap_code='ai-ml'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Advanced concepts, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Advanced concepts.','Apply Advanced concepts concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Advanced concepts within the AI and Machine Learning career roadmap.','exercise','Practise Advanced concepts by creating a small example and explaining your approach.','challenge','Extend your Advanced concepts example to handle a new constraint.','roadmapCode','ai-ml','technologies',array['Python', 'NumPy', 'Pandas', 'scikit-learn', 'Neural Networks']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=4
cross join unnest(array['Model Evaluation', 'Deep Learning', 'Neural Networks']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='ai-ml'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Build & demonstrate','Learn build & demonstrate through Natural Language Processing and related practice.',5 from public.roadmaps where roadmap_code='ai-ml'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Build & demonstrate, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Build & demonstrate.','Apply Build & demonstrate concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Build & demonstrate within the AI and Machine Learning career roadmap.','exercise','Practise Build & demonstrate by creating a small example and explaining your approach.','challenge','Extend your Build & demonstrate example to handle a new constraint.','roadmapCode','ai-ml','technologies',array['Python', 'NumPy', 'Pandas', 'scikit-learn', 'Neural Networks']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=5
cross join unnest(array['Natural Language Processing', 'Generative AI Fundamentals', 'AI Projects']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='ai-ml'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values ('data-science','Data Science','Turn raw data into useful insights through analysis, visualisation, statistics and clear communication.','Data and Analytics','Beginner to Advanced',30,array['Data Scientist', 'Data Analyst', 'Business Intelligence Analyst']::text[],array['Python', 'SQL', 'Pandas', 'Power BI', 'Python', 'Statistics', 'Probability', 'NumPy', 'Pandas', 'SQL', 'Data Cleaning']::text[],array[]::text[],true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Foundations','Learn foundations through Python and related practice.',1 from public.roadmaps where roadmap_code='data-science'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Foundations, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Foundations.','Apply Foundations concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Foundations within the Data Science career roadmap.','exercise','Practise Foundations by creating a small example and explaining your approach.','challenge','Extend your Foundations example to handle a new constraint.','roadmapCode','data-science','technologies',array['Python', 'SQL', 'Pandas', 'Power BI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=1
cross join unnest(array['Python', 'Statistics']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='data-science'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Core skills','Learn core skills through Probability and related practice.',2 from public.roadmaps where roadmap_code='data-science'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Core skills, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Core skills.','Apply Core skills concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Core skills within the Data Science career roadmap.','exercise','Practise Core skills by creating a small example and explaining your approach.','challenge','Extend your Core skills example to handle a new constraint.','roadmapCode','data-science','technologies',array['Python', 'SQL', 'Pandas', 'Power BI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=2
cross join unnest(array['Probability', 'NumPy']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='data-science'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Applied practice','Learn applied practice through Pandas and related practice.',3 from public.roadmaps where roadmap_code='data-science'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Applied practice, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Applied practice.','Apply Applied practice concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Applied practice within the Data Science career roadmap.','exercise','Practise Applied practice by creating a small example and explaining your approach.','challenge','Extend your Applied practice example to handle a new constraint.','roadmapCode','data-science','technologies',array['Python', 'SQL', 'Pandas', 'Power BI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=3
cross join unnest(array['Pandas', 'SQL']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='data-science'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Advanced concepts','Learn advanced concepts through Data Cleaning and related practice.',4 from public.roadmaps where roadmap_code='data-science'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Advanced concepts, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Advanced concepts.','Apply Advanced concepts concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Advanced concepts within the Data Science career roadmap.','exercise','Practise Advanced concepts by creating a small example and explaining your approach.','challenge','Extend your Advanced concepts example to handle a new constraint.','roadmapCode','data-science','technologies',array['Python', 'SQL', 'Pandas', 'Power BI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=4
cross join unnest(array['Data Cleaning', 'Data Visualization']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='data-science'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Build & demonstrate','Learn build & demonstrate through Exploratory Data Analysis and related practice.',5 from public.roadmaps where roadmap_code='data-science'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Build & demonstrate, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Build & demonstrate.','Apply Build & demonstrate concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Build & demonstrate within the Data Science career roadmap.','exercise','Practise Build & demonstrate by creating a small example and explaining your approach.','challenge','Extend your Build & demonstrate example to handle a new constraint.','roadmapCode','data-science','technologies',array['Python', 'SQL', 'Pandas', 'Power BI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=5
cross join unnest(array['Exploratory Data Analysis', 'Machine Learning Fundamentals']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='data-science'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Career preparation','Learn career preparation through Power BI and related practice.',6 from public.roadmaps where roadmap_code='data-science'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Career preparation, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Career preparation.','Apply Career preparation concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Career preparation within the Data Science career roadmap.','exercise','Practise Career preparation by creating a small example and explaining your approach.','challenge','Extend your Career preparation example to handle a new constraint.','roadmapCode','data-science','technologies',array['Python', 'SQL', 'Pandas', 'Power BI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=6
cross join unnest(array['Power BI', 'Real-world Data Projects']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='data-science'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values ('cybersecurity','Cybersecurity','Understand how systems are protected and practise defensive security concepts in safe, controlled learning exercises.','Cybersecurity','Intermediate',28,array['Cybersecurity Analyst', 'Security Engineer', 'SOC Analyst']::text[],array['Linux', 'Networking', 'Python', 'Web Security', 'Computer Fundamentals', 'Networking Fundamentals', 'Linux', 'Python for Security', 'Operating Systems', 'Web Security Fundamentals', 'Ethical Hacking Concepts']::text[],array['Basic computer literacy']::text[],true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Foundations','Learn foundations through Computer Fundamentals and related practice.',1 from public.roadmaps where roadmap_code='cybersecurity'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Foundations, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Foundations.','Apply Foundations concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Foundations within the Cybersecurity career roadmap.','exercise','Practise Foundations by creating a small example and explaining your approach.','challenge','Extend your Foundations example to handle a new constraint.','roadmapCode','cybersecurity','technologies',array['Linux', 'Networking', 'Python', 'Web Security']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=1
cross join unnest(array['Computer Fundamentals', 'Networking Fundamentals']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cybersecurity'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Core skills','Learn core skills through Linux and related practice.',2 from public.roadmaps where roadmap_code='cybersecurity'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Core skills, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Core skills.','Apply Core skills concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Core skills within the Cybersecurity career roadmap.','exercise','Practise Core skills by creating a small example and explaining your approach.','challenge','Extend your Core skills example to handle a new constraint.','roadmapCode','cybersecurity','technologies',array['Linux', 'Networking', 'Python', 'Web Security']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=2
cross join unnest(array['Linux', 'Python for Security']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cybersecurity'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Applied practice','Learn applied practice through Operating Systems and related practice.',3 from public.roadmaps where roadmap_code='cybersecurity'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Applied practice, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Applied practice.','Apply Applied practice concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Applied practice within the Cybersecurity career roadmap.','exercise','Practise Applied practice by creating a small example and explaining your approach.','challenge','Extend your Applied practice example to handle a new constraint.','roadmapCode','cybersecurity','technologies',array['Linux', 'Networking', 'Python', 'Web Security']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=3
cross join unnest(array['Operating Systems', 'Web Security Fundamentals']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cybersecurity'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Advanced concepts','Learn advanced concepts through Ethical Hacking Concepts and related practice.',4 from public.roadmaps where roadmap_code='cybersecurity'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Advanced concepts, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Advanced concepts.','Apply Advanced concepts concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Advanced concepts within the Cybersecurity career roadmap.','exercise','Practise Advanced concepts by creating a small example and explaining your approach.','challenge','Extend your Advanced concepts example to handle a new constraint.','roadmapCode','cybersecurity','technologies',array['Linux', 'Networking', 'Python', 'Web Security']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=4
cross join unnest(array['Ethical Hacking Concepts', 'Vulnerability Assessment']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cybersecurity'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Build & demonstrate','Learn build & demonstrate through Security Tools and related practice.',5 from public.roadmaps where roadmap_code='cybersecurity'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Build & demonstrate, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Build & demonstrate.','Apply Build & demonstrate concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Build & demonstrate within the Cybersecurity career roadmap.','exercise','Practise Build & demonstrate by creating a small example and explaining your approach.','challenge','Extend your Build & demonstrate example to handle a new constraint.','roadmapCode','cybersecurity','technologies',array['Linux', 'Networking', 'Python', 'Web Security']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=5
cross join unnest(array['Security Tools', 'Security Projects']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cybersecurity'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Career preparation','Learn career preparation through Cybersecurity Interview Preparation and related practice.',6 from public.roadmaps where roadmap_code='cybersecurity'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Career preparation, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Career preparation.','Apply Career preparation concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Career preparation within the Cybersecurity career roadmap.','exercise','Practise Career preparation by creating a small example and explaining your approach.','challenge','Extend your Career preparation example to handle a new constraint.','roadmapCode','cybersecurity','technologies',array['Linux', 'Networking', 'Python', 'Web Security']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=6
cross join unnest(array['Cybersecurity Interview Preparation']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cybersecurity'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values ('cloud-devops','Cloud Computing and DevOps','Learn to deploy and operate reliable applications with cloud infrastructure, containers and delivery pipelines.','Cloud and DevOps','Intermediate',30,array['Cloud Engineer', 'DevOps Engineer', 'Site Reliability Engineer']::text[],array['Linux', 'AWS', 'Docker', 'Kubernetes', 'CI/CD', 'Linux Fundamentals', 'Networking', 'Git and GitHub', 'Python or Shell Scripting', 'Cloud Fundamentals', 'AWS Fundamentals', 'Docker']::text[],array['Basic command line familiarity']::text[],true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Foundations','Learn foundations through Linux Fundamentals and related practice.',1 from public.roadmaps where roadmap_code='cloud-devops'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Foundations, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Foundations.','Apply Foundations concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Foundations within the Cloud Computing and DevOps career roadmap.','exercise','Practise Foundations by creating a small example and explaining your approach.','challenge','Extend your Foundations example to handle a new constraint.','roadmapCode','cloud-devops','technologies',array['Linux', 'AWS', 'Docker', 'Kubernetes', 'CI/CD']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=1
cross join unnest(array['Linux Fundamentals', 'Networking']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cloud-devops'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Core skills','Learn core skills through Git and GitHub and related practice.',2 from public.roadmaps where roadmap_code='cloud-devops'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Core skills, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Core skills.','Apply Core skills concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Core skills within the Cloud Computing and DevOps career roadmap.','exercise','Practise Core skills by creating a small example and explaining your approach.','challenge','Extend your Core skills example to handle a new constraint.','roadmapCode','cloud-devops','technologies',array['Linux', 'AWS', 'Docker', 'Kubernetes', 'CI/CD']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=2
cross join unnest(array['Git and GitHub', 'Python or Shell Scripting']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cloud-devops'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Applied practice','Learn applied practice through Cloud Fundamentals and related practice.',3 from public.roadmaps where roadmap_code='cloud-devops'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Applied practice, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Applied practice.','Apply Applied practice concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Applied practice within the Cloud Computing and DevOps career roadmap.','exercise','Practise Applied practice by creating a small example and explaining your approach.','challenge','Extend your Applied practice example to handle a new constraint.','roadmapCode','cloud-devops','technologies',array['Linux', 'AWS', 'Docker', 'Kubernetes', 'CI/CD']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=3
cross join unnest(array['Cloud Fundamentals', 'AWS Fundamentals']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cloud-devops'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Advanced concepts','Learn advanced concepts through Docker and related practice.',4 from public.roadmaps where roadmap_code='cloud-devops'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Advanced concepts, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Advanced concepts.','Apply Advanced concepts concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Advanced concepts within the Cloud Computing and DevOps career roadmap.','exercise','Practise Advanced concepts by creating a small example and explaining your approach.','challenge','Extend your Advanced concepts example to handle a new constraint.','roadmapCode','cloud-devops','technologies',array['Linux', 'AWS', 'Docker', 'Kubernetes', 'CI/CD']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=4
cross join unnest(array['Docker', 'Kubernetes']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cloud-devops'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Build & demonstrate','Learn build & demonstrate through CI/CD and related practice.',5 from public.roadmaps where roadmap_code='cloud-devops'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Build & demonstrate, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Build & demonstrate.','Apply Build & demonstrate concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Build & demonstrate within the Cloud Computing and DevOps career roadmap.','exercise','Practise Build & demonstrate by creating a small example and explaining your approach.','challenge','Extend your Build & demonstrate example to handle a new constraint.','roadmapCode','cloud-devops','technologies',array['Linux', 'AWS', 'Docker', 'Kubernetes', 'CI/CD']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=5
cross join unnest(array['CI/CD', 'Infrastructure as Code']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cloud-devops'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Career preparation','Learn career preparation through Monitoring and related practice.',6 from public.roadmaps where roadmap_code='cloud-devops'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Career preparation, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Career preparation.','Apply Career preparation concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Career preparation within the Cloud Computing and DevOps career roadmap.','exercise','Practise Career preparation by creating a small example and explaining your approach.','challenge','Extend your Career preparation example to handle a new constraint.','roadmapCode','cloud-devops','technologies',array['Linux', 'AWS', 'Docker', 'Kubernetes', 'CI/CD']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=6
cross join unnest(array['Monitoring', 'Deployment Projects']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='cloud-devops'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values ('app-development','App Development','Design and build mobile applications with Flutter, from interface basics to testing and deployment.','Mobile Development','Beginner to Advanced',26,array['Mobile App Developer', 'Flutter Developer', 'Product Engineer']::text[],array['Dart', 'Flutter', 'APIs', 'Mobile UI', 'Programming Fundamentals', 'Dart', 'Flutter', 'UI Development', 'State Management', 'APIs', 'Database Integration']::text[],array[]::text[],true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Foundations','Learn foundations through Programming Fundamentals and related practice.',1 from public.roadmaps where roadmap_code='app-development'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Foundations, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Foundations.','Apply Foundations concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Foundations within the App Development career roadmap.','exercise','Practise Foundations by creating a small example and explaining your approach.','challenge','Extend your Foundations example to handle a new constraint.','roadmapCode','app-development','technologies',array['Dart', 'Flutter', 'APIs', 'Mobile UI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=1
cross join unnest(array['Programming Fundamentals', 'Dart']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='app-development'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Core skills','Learn core skills through Flutter and related practice.',2 from public.roadmaps where roadmap_code='app-development'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Core skills, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Core skills.','Apply Core skills concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Core skills within the App Development career roadmap.','exercise','Practise Core skills by creating a small example and explaining your approach.','challenge','Extend your Core skills example to handle a new constraint.','roadmapCode','app-development','technologies',array['Dart', 'Flutter', 'APIs', 'Mobile UI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=2
cross join unnest(array['Flutter', 'UI Development']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='app-development'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Applied practice','Learn applied practice through State Management and related practice.',3 from public.roadmaps where roadmap_code='app-development'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Applied practice, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Applied practice.','Apply Applied practice concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Applied practice within the App Development career roadmap.','exercise','Practise Applied practice by creating a small example and explaining your approach.','challenge','Extend your Applied practice example to handle a new constraint.','roadmapCode','app-development','technologies',array['Dart', 'Flutter', 'APIs', 'Mobile UI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=3
cross join unnest(array['State Management', 'APIs']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='app-development'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Advanced concepts','Learn advanced concepts through Database Integration and related practice.',4 from public.roadmaps where roadmap_code='app-development'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Advanced concepts, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Advanced concepts.','Apply Advanced concepts concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Advanced concepts within the App Development career roadmap.','exercise','Practise Advanced concepts by creating a small example and explaining your approach.','challenge','Extend your Advanced concepts example to handle a new constraint.','roadmapCode','app-development','technologies',array['Dart', 'Flutter', 'APIs', 'Mobile UI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=4
cross join unnest(array['Database Integration', 'Authentication']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='app-development'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Build & demonstrate','Learn build & demonstrate through Mobile App Testing and related practice.',5 from public.roadmaps where roadmap_code='app-development'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Build & demonstrate, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Build & demonstrate.','Apply Build & demonstrate concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Build & demonstrate within the App Development career roadmap.','exercise','Practise Build & demonstrate by creating a small example and explaining your approach.','challenge','Extend your Build & demonstrate example to handle a new constraint.','roadmapCode','app-development','technologies',array['Dart', 'Flutter', 'APIs', 'Mobile UI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=5
cross join unnest(array['Mobile App Testing', 'App Deployment']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='app-development'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,'Career preparation','Learn career preparation through Real-world Projects and related practice.',6 from public.roadmaps where roadmap_code='app-development'
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;
insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       'A guided introduction to each concept in Career preparation, with a practical explanation and a short exercise.',
       jsonb_build_array('Explain the core ideas of Career preparation.','Apply Career preparation concepts in a small practical task.'),
       t.topic_order,35,
       jsonb_build_object('introduction','Learn Career preparation within the App Development career roadmap.','exercise','Practise Career preparation by creating a small example and explaining your approach.','challenge','Extend your Career preparation example to handle a new constraint.','roadmapCode','app-development','technologies',array['Dart', 'Flutter', 'APIs', 'Mobile UI']::text[])
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=6
cross join unnest(array['Real-world Projects']::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code='app-development'
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Customer Complaint Handling','Turn a frustrated customer conversation into a thoughtful resolution.','Communication','Intermediate',12,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Professional Email Writing','Write a clear, polished update for a time-sensitive project.','Communication','Beginner',8,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Team Communication','Align a cross-functional team when priorities begin to drift.','Communication','Intermediate',15,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Python Debugging','Trace a data-processing bug and explain your fix to a teammate.','Technical','Advanced',20,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Spreadsheet Analysis','Find the story hiding in a messy quarterly dataset.','Technical','Beginner',14,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Technical Problem Solving','Diagnose a production issue and communicate your next steps.','Technical','Advanced',18,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Project Planning','Build a realistic launch plan with dependencies and trade-offs.','Business','Intermediate',16,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Business Decision Making','Choose a path forward with incomplete data and limited time.','Business','Advanced',15,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Task Prioritisation','Make a calm, defensible plan when everything feels urgent.','Business','Beginner',9,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Time Management','Rebalance a packed week without dropping important work.','Professional','Beginner',10,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Leadership','Give direction and build confidence during a team setback.','Professional','Advanced',18,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values ('Workplace Conflict Resolution','Help two colleagues move from friction to shared action.','Professional','Intermediate',16,true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;
commit;
