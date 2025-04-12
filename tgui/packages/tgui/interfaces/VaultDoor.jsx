import { useBackend } from '../backend';
import { Button, LabeledList, Section, Box } from 'tgui-core/components';
import { Window } from '../layouts';
import { Component } from 'react';

export class VaultDoor extends Component {
  constructor(props) {
    super(props);
    this.state = {
      inputCode: '',
    };

    this.handleButtonClick = this.handleButtonClick.bind(this);
    this.handleClear = this.handleClear.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleButtonClick(value) {
    this.setState(prevState => ({
      inputCode: prevState.inputCode + value,
    }));
  }

  handleClear() {
    this.setState({ inputCode: '' });
  }

  handleSubmit() {
    const { act } = useBackend();
    act('submit_pincode', { pincode: this.state.inputCode });
    this.setState({ inputCode: '' });
  }

  render() {
    const { data } = useBackend();
    const { pincode } = data;
    const { inputCode } = this.state;

    return (
      <Window resizable>
        <Window.Content scrollable>
          <Section title="Vault Door">
            <LabeledList>
              <LabeledList.Item label="Enter Pincode">
                <Box>
                  <Box>{inputCode}</Box>
                  <Box>
                    {[1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((num) => (
                      <Button
                        key={num}
                        content={num}
                        onClick={() => this.handleButtonClick(num.toString())}
                      />
                    ))}
                  </Box>
                  <Box>
                    <Button content="Submit" onClick={this.handleSubmit} />
                    <Button content="Clear" onClick={this.handleClear} />
                  </Box>
                </Box>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Window.Content>
      </Window>
    );
  }
}
