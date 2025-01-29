import { Component } from 'inferno';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { WinXP } from './WindowsXP/index';

export class WindowsXP extends Component {
  render() {
    const { act, data } = useBackend(this.context);
    return (
      <Window width={1200} height={678} theme="light">
        <WinXP data={data} act={act} />
      </Window>
    );
  }
}
