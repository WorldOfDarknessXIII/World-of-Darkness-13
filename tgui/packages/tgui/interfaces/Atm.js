import { Window } from "../layouts";
import { AtmScreen } from "./Atm/index";
import { useBackend } from "../backend";
import { Component } from 'inferno';

export class Atm extends Component {
  render() {
    const { act, data } = useBackend(this.context);
    return (
      <Window width={500} height={500} theme="light">
        <AtmScreen data={data} act={act}/>
      </Window>
    );
  };
};
