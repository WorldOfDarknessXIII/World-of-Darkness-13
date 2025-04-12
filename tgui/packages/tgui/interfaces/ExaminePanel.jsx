// THIS IS A SKYRAT UI FILE
import { useState } from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { ByondUi, Section, Stack, Tabs } from 'tgui-core/components';
import { Window } from '../layouts';

const formatURLs = (text) => {
  if (!text) return;
  const parts = [];
  let regex = /https?:\/\/[^\s/$.?#].[^\s]*/gi;
  let lastIndex = 0;

  text.replace(regex, (url, index) => {
    parts.push(text.substring(lastIndex, index));
    parts.push(
      <a
        style={{
          color: '#0591e3',
          'text-decoration': 'none',
        }}
        href={url}
      >
        {url}
      </a>,
    );
    lastIndex = index + url.length;
    return url;
  });

  parts.push(text.substring(lastIndex));

  return <div>{parts}</div>;
};

export const ExaminePanel = (props) => {
  const [tabIndex, setTabIndex] = useState(1);
  const [lowerTabIndex, setLowerTabIndex] = useState(1);
  const { act, data } = useBackend();
  const {
    character_name,
    obscured,
    flavor_text,
    ooc_notes,
  } = data;
  return (
    <Window
      title={character_name + "'s Examine Panel"}
      width={900}
      height={670}
    >
      <Window.Content>
        <Stack fill>
          <Stack.Item grow>
            <Tabs fluid>
              <Tabs.Tab
                selected={tabIndex === 1}
                onClick={() => setTabIndex(1)}
              >
                <Section fitted title={'Flavor Text'} />
              </Tabs.Tab>
            </Tabs>
            {tabIndex === 1 && (
              <Section
                style={{ 'overflow-y': 'scroll' }}
                fitted
                preserveWhitespace
                minHeight="50%"
                maxHeight="50%"
                fontSize="14px"
                lineHeight="1.7"
                textIndent="3em"
              >
                {formatURLs(flavor_text)}
              </Section>
            )}
            <Tabs fluid>
              <Tabs.Tab
                selected={lowerTabIndex === 1}
                onClick={() => setLowerTabIndex(1)}
              >
                <Section fitted title={'OOC Notes'} />
              </Tabs.Tab>
              </Tabs>
              {lowerTabIndex === 1 && (
              <Section
                style={{ 'overflow-y': 'scroll' }}
                preserveWhitespace
                fitted
                minHeight="35%"
                maxHeight="35%"
                fontSize="14px"
                lineHeight="1.5"
              >
                <Stack.Item>{formatURLs(ooc_notes)}</Stack.Item>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
