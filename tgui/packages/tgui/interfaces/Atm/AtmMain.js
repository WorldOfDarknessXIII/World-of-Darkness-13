import { useBackend } from '../../backend';
import { useLocalState } from '../../backend';
import { Button, Input, LabeledList, Section, Box } from '../../components';
import { Window } from '../../layouts';

export const AtmMain = (props, context) => {
  const { act, data } = useBackend(context);
  const [transferAmount, setTransferAmount] = useLocalState(context, "transfer_amount", "");
  const [withdrawAmount, setWithdrawAmount] = useLocalState(context, "withdraw_amount", "");
  const [newPin, setNewPin] = useLocalState(context, "new_pin", "");
  const [selectedAccount, setSelectedAccount] = useLocalState(context, "selected_account", "");
  const [searchTerm, setSearchTerm] = useLocalState(context, "search_term", "");
  const buttonStyle = { minWidth: '120px', flex: 3 };

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

  accounts = accounts.sort((a, b) => {
    const nameA = (a.account_owner || "").toLowerCase();
    const nameB = (b.account_owner || "").toLowerCase();
    return nameA.localeCompare(nameB);
  });

  const filteredAccounts = accounts.filter(account =>
    (account.account_owner || "Unnamed Account").toLowerCase().includes(searchTerm.toLowerCase())
  );

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
            <Box display="flex" flexDirection="column" alignItems="stretch" gap={2}>
              <Box display="flex" alignItems="center" gap={1}>
                <Button content="Withdraw" onClick={handleWithdraw} style={{ buttonStyle }} />
                <Input
                  value={withdrawAmount}
                  onInput={(e, value) => setWithdrawAmount(value)}
                  placeholder="Withdraw Amount"
                  style={{ flex: 3 }}
                />
              </Box>
              <Box display="flex" alignItems="center" gap={1}>
                <Button content="Change Pin" onClick={handleChangePin} style={{ buttonStyle }} />
                <Input
                  value={newPin}
                  onInput={(e, value) => setNewPin(value)}
                  placeholder="New PIN"
                  style={{ flex: 3 }}
                />
              </Box>
              <Box display="flex" alignItems="center" gap={1}>
                <Button content="Deposit" onClick={handleDeposit} style={{ buttonStyle }} />
              </Box>
              <Box display="flex" alignItems="center" gap={1}>
                <Button content="Log Out" onClick={handleLogout} style={{ buttonStyle }} />
              </Box>
              <Box mt={2}>
                <Box mb={1} fontWeight="bold">
                  Select Target Account
                </Box>
                {/* Search Input */}
                <Input
                  value={searchTerm}
                  onInput={(e, value) => setSearchTerm(value)}
                  placeholder="Search accounts"
                  mb={1}
                  width="100%"
                />
                {/* Account List */}
                <Box className="account-list" border="1px solid #ccc" borderRadius="4px" p={2}>
                  {filteredAccounts.length > 0 ? (
                    filteredAccounts.map((account, index) => (
                      <Box
                        key={index}
                        className={`account-item ${selectedAccount === account.account_owner ? 'selected' : ''}`}
                        p={1}
                        mb={1}
                        cursor="pointer"
                        borderRadius="4px"
                        backgroundColor={selectedAccount === account.account_owner ? '#007bff' : '#f8f9fa'}
                        color={selectedAccount === account.account_owner ? '#fff' : '#000'}
                        onClick={() => setSelectedAccount(account.account_owner)}
                      >
                        {account.account_owner || "Unnamed Account"}
                      </Box>
                    ))
                  ) : (
                    <Box color="red" fontStyle="italic">
                      No accounts found.
                    </Box>
                  )}
                </Box>
              </Box>
              <Box display="flex" alignItems="center" gap={1}>
                <Button content="Transfer" onClick={handleTransfer} style={{ buttonStyle }} />
                <Input
                  value={transferAmount}
                  onInput={(e, value) => setTransferAmount(value)}
                  placeholder="Transfer Amount"
                  style={{ flex: 3 }}
                />
              </Box>
            </Box>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
