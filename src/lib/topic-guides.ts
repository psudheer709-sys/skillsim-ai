import { getBeginnerActivity } from '@/lib/beginner-activities';

type TopicForGuide = {
  topic_title: string;
  topic_description?: string | null;
  learning_objectives?: string[] | null;
  content?: Record<string, unknown> | null;
};

export type TopicGuide = {
  summary: string;
  beginnerExplanation: string;
  objectives?: string[];
  resourceLabel?: string;
  resourceUrl?: string;
  steps: { title: string; detail: string }[];
  example?: string;
  exampleTitle?: string;
  exampleExplanation?: string;
  practice: string;
};

const htmlGuide: TopicGuide = {
  summary: 'HTML gives a page its structure. You will create a small page, add meaningful content, and check it in your browser.',
  beginnerExplanation: 'Think of a web page like a notebook. HTML puts a label on each part: this is the title, this is a paragraph, and this is a link. You do not need to memorize every tag; start with a few and see what the browser does.',
  objectives: ['Recognize an HTML element, its tags, content, and attributes.', 'Build a page with a document structure, headings, paragraphs, lists, and links.', 'Preview the page in a browser and correct simple markup mistakes.'],
  resourceLabel: 'MDN: Basic HTML syntax',
  resourceUrl: 'https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Structuring_content/Basic_HTML_syntax',
  steps: [
    { title: 'Open the sample page', detail: 'The code below is a small web page. The words inside <h1> become the big heading; the words inside <p> become a paragraph.' },
    { title: 'Notice the start and end tags', detail: 'Most HTML parts have a start tag such as <p> and an end tag such as </p>. The text goes between them. Think of the tags as opening and closing a box around the text.' },
    { title: 'Change one thing', detail: 'Replace “My learning journey” with your name. Leave the <h1> and </h1> tags in place so the browser still knows it is a heading.' },
    { title: 'Run it and look', detail: 'Click Run preview below. The preview shows the page the browser builds from your HTML. Change the paragraph too, run it again, and compare the result.' },
    { title: 'Build your own introduction', detail: 'Use the practice task below to add your own heading, paragraphs, interests, and link. Preview it and check that each part appears in the right place.' },
  ],
  example: '<!doctype html>\n<html lang="en">\n  <head>\n    <meta charset="utf-8">\n    <title>My first page</title>\n  </head>\n  <body>\n    <h1>My learning journey</h1>\n    <p>I am learning to build for the web.</p>\n    <a href="https://developer.mozilla.org/">Visit MDN</a>\n  </body>\n</html>',
  practice: 'Build a one-page introduction about yourself. Include a page title, one main heading, two paragraphs, a list of three interests, and one useful link. Open it in your browser and fix any missing or mismatched tags.',
};

const cssGuide: TopicGuide = {
  summary: 'CSS controls how HTML looks. You will connect a stylesheet, select page elements, and make a simple layout readable on small screens.',
  beginnerExplanation: 'HTML says what is on the page. CSS is like choosing the colors, clothes, and spacing for those things. A CSS rule says which part to change and what it should look like.',
  objectives: ['Connect an external stylesheet to an HTML document.', 'Write CSS rules with selectors, properties, and values.', 'Use typography, color, and spacing to improve a page.'],
  resourceLabel: 'MDN: Getting started with CSS',
  resourceUrl: 'https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Styling_basics/Getting_started',
  steps: [
    { title: 'Look at the sample page', detail: 'The preview already has a heading and a paragraph. CSS will change their appearance without changing the words.' },
    { title: 'Pick what to change', detail: 'The word body selects the whole page. The word h1 selects the main heading. The text inside the braces tells the browser what style to use.' },
    { title: 'Change a color', detail: 'Find “rebeccapurple” in the example and replace it with “teal”. Click Run preview and watch the heading change color.' },
    { title: 'Try a different size', detail: 'Change the heading color back, then add font-size: 32px; inside the h1 rule. Run the preview again to see the heading grow.' },
    { title: 'Style your own page', detail: 'Use the practice task below to style your introduction. Preview it, change one style at a time, and keep the version that is easiest to read.' },
  ],
  example: 'body {\n  font-family: system-ui, sans-serif;\n  line-height: 1.6;\n  margin: 2rem;\n}\n\nh1 {\n  color: rebeccapurple;\n}',
  practice: 'Style your introduction page: set a readable font, add spacing around the content, choose a heading color, and make links easy to recognize. Resize the browser and adjust anything that feels cramped.',
};

const javascriptGuide: TopicGuide = {
  summary: 'JavaScript adds behavior to a page. You will connect a script, respond to a button click, and check the result in the browser.',
  beginnerExplanation: 'HTML puts a button on the page. CSS makes it look a certain way. JavaScript tells the button what to do when someone clicks it, like a light switch controlling a lamp.',
  objectives: ['Connect a JavaScript file to a web page.', 'Select an element and respond to a click event.', 'Use the browser console to spot and fix a simple error.'],
  resourceLabel: 'MDN: A first splash into JavaScript',
  resourceUrl: 'https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/A_first_splash',
  steps: [
    { title: 'Look at the button', detail: 'The preview has a button and a message. JavaScript can find both of them and change the message after a click.' },
    { title: 'Read the first two lines', detail: 'The first line finds the button. The second line finds the message area. The names in quotes tell JavaScript which parts of the page to use.' },
    { title: 'Read the click action', detail: 'The click listener waits for the button. Everything inside its curly braces happens when the button is pressed.' },
    { title: 'Change the message', detail: 'Replace the sample message with your own words. Click Run preview, then press the preview button to see your message.' },
    { title: 'Make the button yours', detail: 'Use the practice task below to add a welcome action. Run the page and click the button to confirm the message changes.' },
  ],
  example: 'const button = document.querySelector("#try-button");\nconst message = document.querySelector("#message");\n\nbutton.addEventListener("click", () => {\n  message.textContent = "Great job! You made this page respond.";\n});',
  practice: 'Add a button to your introduction page. When clicked, show a short welcome message. Then change the message and test again.',
};

const resources: [string, string, string][] = [
  ['javascript', 'MDN: JavaScript first steps', 'https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting'],
  ['html', 'MDN: Learn HTML', 'https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Structuring_content'],
  ['css', 'MDN: CSS styling basics', 'https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Styling_basics'],
  ['python', 'Python: The official tutorial', 'https://docs.python.org/3/tutorial/'],
  ['numpy', 'NumPy: Learn', 'https://numpy.org/learn/'],
  ['pandas', 'Pandas: Getting started tutorials', 'https://pandas.pydata.org/docs/getting_started/intro_tutorials/index.html'],
  ['react', 'React: Quick start', 'https://react.dev/learn'],
  ['next.js', 'Next.js: Learn', 'https://nextjs.org/learn'],
  ['node.js', 'Node.js: Learn', 'https://nodejs.org/en/learn'],
  ['express', 'Express: Getting started', 'https://expressjs.com/en/starter/installing.html'],
  ['git', 'Git: Getting started', 'https://git-scm.com/docs/gittutorial'],
  ['c++', 'Learn C++', 'https://www.learncpp.com/'],
  ['java', 'Java: Learn', 'https://dev.java/learn/'],
  ['flutter', 'Flutter: Get started', 'https://docs.flutter.dev/get-started'],
  ['dart', 'Dart: Get started', 'https://dart.dev/learn'],
  ['docker', 'Docker: Get started', 'https://docs.docker.com/get-started/'],
  ['kubernetes', 'Kubernetes: Learn', 'https://kubernetes.io/docs/tutorials/'],
  ['machine learning', 'scikit-learn: Getting started', 'https://scikit-learn.org/stable/getting_started.html'],
  ['scikit-learn', 'scikit-learn: Getting started', 'https://scikit-learn.org/stable/getting_started.html'],
  ['sql', 'PostgreSQL: Tutorial', 'https://www.postgresql.org/docs/current/tutorial.html'],
  ['postgres', 'PostgreSQL: Tutorial', 'https://www.postgresql.org/docs/current/tutorial.html'],
  ['api', 'MDN: Overview of HTTP', 'https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview'],
  ['cybersecurity', 'OWASP: Web Security Testing Guide', 'https://owasp.org/www-project-web-security-testing-guide/'],
  ['security', 'OWASP: Web Security Testing Guide', 'https://owasp.org/www-project-web-security-testing-guide/'],
  ['network', 'Cloudflare: What is networking?', 'https://www.cloudflare.com/learning/network-layer/what-is-the-network-layer/'],
  ['aws', 'AWS Skill Builder', 'https://skillbuilder.aws/'],
  ['cloud', 'AWS Skill Builder: Cloud learning', 'https://skillbuilder.aws/'],
  ['power bi', 'Microsoft Learn: Power BI', 'https://learn.microsoft.com/en-us/training/powerplatform/power-bi/'],
];

function genericGuide(topic: TopicForGuide, roadmapTitle: string): TopicGuide {
  const title = topic.topic_title;
  const activity = getBeginnerActivity(title, roadmapTitle);
  const resource = resources.find(([keyword]) => title.toLowerCase().includes(keyword));
  const objectives = (topic.learning_objectives ?? []).filter((objective) =>
    Boolean(objective) && !/^(explain the core ideas of|apply .+ concepts in)/i.test(objective.trim()),
  );
  const contentSections = Object.entries(topic.content ?? {}).filter((entry): entry is [string, string] => {
    if (typeof entry[1] !== 'string' || !entry[1].trim()) return false;
    const [heading, detail] = entry;
    if (/^(roadmapcode|introduction)$/i.test(heading.replace(/[_\s-]/g, ''))) return false;
    if (/^(practise|practice) .+ by creating a small example and explaining your approach\.?$/i.test(detail.trim())) return false;
    if (/^extend your .+ example to handle a new constraint\.?$/i.test(detail.trim())) return false;
    if (/^learn .+ within the .+ career roadmap\.?$/i.test(detail.trim())) return false;
    return true;
  });
  const description = topic.topic_description?.trim();

  return {
    summary: activity.explanation,
    beginnerExplanation: activity.explanation,
    ...(objectives.length ? { objectives } : {}),
    ...(resource ? { resourceLabel: resource[1], resourceUrl: resource[2] } : {}),
    steps: [
      ...activity.steps,
      ...contentSections.map(([heading, detail]) => ({ title: heading.replace(/[_-]/g, ' '), detail })),
    ],
    exampleTitle: activity.exampleTitle,
    example: activity.example,
    exampleExplanation: activity.exampleExplanation,
    practice: activity.practice,
  };
}

export function getTopicGuide(topic: TopicForGuide, roadmapTitle = ''): TopicGuide {
  const title = topic.topic_title.toLowerCase();
  if (title === 'html' || title.includes('html fundamentals')) return htmlGuide;
  if (title === 'css' || title.includes('css fundamentals')) return cssGuide;
  if (title === 'javascript' || title.includes('javascript fundamentals')) return javascriptGuide;
  return genericGuide(topic, roadmapTitle);
}

export function getTopicPlaygroundMode(topicTitle: string): 'html' | 'css' | 'javascript' | null {
  const title = topicTitle.toLowerCase();
  if (title === 'html' || title.includes('html fundamentals')) return 'html';
  if (title === 'css' || title.includes('css fundamentals')) return 'css';
  if (title === 'javascript' || title.includes('javascript fundamentals')) return 'javascript';
  return null;
}

