import { useBackend } from '../../backend';
import { useLocalState } from '../../backend';
import { Button, Input, LabeledList, Section } from 'tgui-core/components';
import { Window } from '../../layouts';

export const AtmLogin = (props) => {
  const { act, data } = useBackend();
  const [entered_code, setEnteredCode] = useLocalState(
    'login_code',
    '',
  );

  const { account_owner, code } = data;

  const handleLogin = () => {
    act('login', { code: entered_code });
  };
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Please enter your code">
          <LabeledList>
            <LabeledList.Item label="code">
              <Input
                value={entered_code}
                onInput={(e, value) => setEnteredCode(value)}
                placeholder="Enter code here"
              />
            </LabeledList.Item>
            <LabeledList.Item>
              <Button content="Log In" onClick={handleLogin} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
