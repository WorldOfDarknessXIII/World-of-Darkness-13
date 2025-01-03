import { useBackend } from '../../backend';
import { useLocalState } from '../../backend';
import { Button, Input, LabeledList, Section } from '../../components';
import { Window } from '../../layouts';

export const AtmMain = (props, context) => {
  const { act, data } = useBackend(context);
  const [entered_code, setEnteredCode] = useLocalState(context, "login_code", "");

  const {
    balance,
    account_owner,
    bank_id,
    code

  } = data;

  const handleLogout = () => {
    act('logout');
  };
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Account Owner">
              {account_owner}
            </LabeledList.Item>
            <LabeledList.Item label="Balance">
              {balance}
            </LabeledList.Item>
            <LabeledList.Item label="Actions">
              <Button
                content="Log Out"
                onClick={() => act("logout")}
                />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
