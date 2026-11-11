import { writeFile } from 'node:fs/promises';
import { roadmaps } from '../src/lib/roadmaps.ts';
import { simulations } from '../src/lib/data.ts';

const q = (value) => `'${String(value ?? '').replaceAll("'", "''")}'`;
const textArray = (values) => values.length ? `array[${values.map(q).join(', ')}]::text[]` : `array[]::text[]`;
const statements = ['-- Generated from src/lib/roadmaps.ts and src/lib/data.ts. Safe to rerun.', 'begin;'];
for (const road of roadmaps) {
  statements.push(`insert into public.roadmaps(roadmap_code,title,description,category,difficulty,estimated_duration,career_opportunities,skills_covered,prerequisites,is_active)
values (${q(road.id)},${q(road.title)},${q(road.description)},${q(road.category)},${q(road.difficulty)},${road.durationWeeks},${textArray(road.opportunities)},${textArray([...road.technologies,...road.skills])},${textArray(road.prerequisites)},true)
on conflict (roadmap_code) do update set title=excluded.title,description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,career_opportunities=excluded.career_opportunities,skills_covered=excluded.skills_covered,prerequisites=excluded.prerequisites,is_active=true,updated_at=now();`);
  for (let stageIndex=0; stageIndex<road.stages.length; stageIndex++) {
    const stage=road.stages[stageIndex];
    const first=stage.topics[0]||stage.title;
    statements.push(`insert into public.roadmap_stages(roadmap_id,stage_name,description,stage_order)
select id,${q(stage.title)},${q(`Learn ${stage.title.toLowerCase()} through ${first} and related practice.`)},${stageIndex+1} from public.roadmaps where roadmap_code=${q(road.id)}
on conflict (roadmap_id,stage_order) do update set stage_name=excluded.stage_name,description=excluded.description;`);
    const titles=stage.topics.map(q).join(', ');
    statements.push(`insert into public.roadmap_topics(roadmap_id,stage_id,topic_title,topic_description,learning_objectives,topic_order,estimated_duration,content)
select r.id,s.id,t.topic_title,
       ${q(`A guided introduction to each concept in ${stage.title}, with a practical explanation and a short exercise.`)},
       jsonb_build_array(${q(`Explain the core ideas of ${stage.title}.`)},${q(`Apply ${stage.title} concepts in a small practical task.`)}),
       t.topic_order,35,
       jsonb_build_object('introduction',${q(`Learn ${stage.title} within the ${road.title} career roadmap.`)},'exercise',${q(`Practise ${stage.title} by creating a small example and explaining your approach.`)},'challenge',${q(`Extend your ${stage.title} example to handle a new constraint.`)},'roadmapCode',${q(road.id)},'technologies',${textArray(road.technologies)})
from public.roadmaps r join public.roadmap_stages s on s.roadmap_id=r.id and s.stage_order=${stageIndex+1}
cross join unnest(array[${titles}]::text[]) with ordinality as t(topic_title,topic_order)
where r.roadmap_code=${q(road.id)}
on conflict (stage_id,topic_order) do update set roadmap_id=excluded.roadmap_id,topic_title=excluded.topic_title,topic_description=excluded.topic_description,learning_objectives=excluded.learning_objectives,estimated_duration=excluded.estimated_duration,content=excluded.content;`);
  }
}
for (const simulation of simulations) {
  const minutes=Number.parseInt(simulation.time,10);
  statements.push(`insert into public.simulations(title,description,category,difficulty,estimated_duration,is_active)
values (${q(simulation.title)},${q(simulation.description)},${q(simulation.category)},${q(simulation.level)},${minutes},true)
on conflict (title) do update set description=excluded.description,category=excluded.category,difficulty=excluded.difficulty,estimated_duration=excluded.estimated_duration,is_active=true;`);
}
statements.push('commit;','');
await writeFile(new URL('../supabase/seed.sql', import.meta.url), statements.join('\n'), 'utf8');
console.log(`Wrote seed for ${roadmaps.length} roadmaps (${roadmaps.reduce((n,r)=>n+r.stages.reduce((m,s)=>m+s.topics.length,0),0)} topics) and ${simulations.length} simulations.`);
