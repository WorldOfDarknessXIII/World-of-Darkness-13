import { toFixed } from 'tgui-core/math';
import { useBackend } from '../backend';
import { Button, Stack, NumberInput, Section } from 'tgui-core/components';
import { Window } from '../layouts';

export const Signaler = (props) => {
  const { act, data } = useBackend();
  const { code, frequency, minFrequency, maxFrequency } = data;
  return (
    <Window width={280} height={132}>
      <Window.Content>
        <Section>
          <Stack>
            <Stack.Item grow color="label">
              Frequency:
            </Stack.Item>
            <Stack.Item>
              <NumberInput
                animate
                unit="kHz"
                step={0.2}
                stepPixelSize={6}
                minValue={minFrequency / 10}
                maxValue={maxFrequency / 10}
                value={frequency / 10}
                format={(value) => toFixed(value, 1)}
                width="80px"
                onDrag={(e, value) =>
                  act('freq', {
                    freq: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                ml={1.3}
                icon="sync"
                content="Reset"
                onClick={() =>
                  act('reset', {
                    reset: 'freq',
                  })
                }
              />
            </Stack.Item>
          </Stack>
          <Stack mt={0.6}>
            <Stack.Item grow color="label">
              Code:
            </Stack.Item>
            <Stack.Item>
              <NumberInput
                animate
                step={1}
                stepPixelSize={6}
                minValue={1}
                maxValue={100}
                value={code}
                width="80px"
                onDrag={(e, value) =>
                  act('code', {
                    code: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                ml={1.3}
                icon="sync"
                content="Reset"
                onClick={() =>
                  act('reset', {
                    reset: 'code',
                  })
                }
              />
            </Stack.Item>
          </Stack>
          <Stack mt={0.8}>
            <Stack.Item>
              <Button
                mb={-0.1}
                fluid
                icon="arrow-up"
                content="Send Signal"
                textAlign="center"
                onClick={() => act('signal')}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
