import { useBackend } from '../../backend';
import { useLocalState } from '../../backend';
import { Button, Input, LabeledList, Section, Box, Dropdown } from '../../components';
import { Window } from '../../layouts';

export const AtmMain = (props, context) => {
  const { act, data } = useBackend(context);
  const [transferAmount, setTransferAmount] = useLocalState(context, "transfer_amount", "");
  const [withdrawAmount, setWithdrawAmount] = useLocalState(context, "withdraw_amount", "");
  const [newPin, setNewPin] = useLocalState(context, "new_pin", "");
  const [selectedAccount, setSelectedAccount] = useLocalState(context, "selected_account", "");

  const {
    balance,
    account_owner,
    atm_balance,
    bank_account_list = "[]",
  } = data;

  let accounts = [];
  try {
    accounts = JSON.parse(bank_account_list);
    if (!Array.isArray(accounts)) {
      accounts = [];
    }
  } catch (error) {
    console.error("Failed to parse bank account list", error);
  }
  const handleLogout = () => {
    act('logout');
  };

  const handleWithdraw = () => {
    act('withdraw', { withdraw_amount: withdrawAmount });
  };

  const handleTransfer = () => {
    act('transfer', { transfer_amount: transferAmount, target_account: selectedAccount });
  };

  const handleDeposit = () => {
    act('deposit');
  };

  const handleChangePin = () => {
    act('change_pin', { new_pin: newPin });
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
            <LabeledList.Item label="Money in ATM">
              {atm_balance}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={2}>
            <Box display="flex" alignItems="center" mb={1}>
              <Button content="Withdraw" onClick={handleWithdraw} />
              <Input
                value={withdrawAmount}
                onInput={(e, value) => setWithdrawAmount(value)}
                placeholder="Withdraw Amount"
                ml={1}
              />
            </Box>
            <Box display="flex" alignItems="center" mb={1}>
              <Button content="Transfer" onClick={handleTransfer} />
              <Input
                value={transferAmount}
                onInput={(e, value) => setTransferAmount(value)}
                placeholder="Transfer Amount"
                ml={1}
              />
              <Dropdown
                options={accounts.map(account => ({
                  value: account.account_owner,
                  text: account.account_owner || "Unnamed Account",
                }))}
                selected={selectedAccount}
                onSelected={(value) => setSelectedAccount(value)}
                placeholder = "Select an Account"
                style={{
                  width: '300px',
                  maxHeight: '200px',
                  overflowY: 'auto',
                }}
              />

            </Box>
            <Box display="flex" alignItems="center" mb={1}>
              <Button content="Change Pin" onClick={handleChangePin} />
              <Input
                value={newPin}
                onInput={(e, value) => setNewPin(value)}
                placeholder="New PIN"
                ml={1}
              />
            </Box>
            <Box display="flex" alignItems="center" mb={1}>
              <Button content="Deposit" onClick={handleDeposit} />
            </Box>
            <Box display="flex" alignItems="center">
              <Button content="Log Out" onClick={handleLogout} />
            </Box>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
