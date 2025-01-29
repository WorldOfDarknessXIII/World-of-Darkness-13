import { useBackend } from '../backend';
import { Window } from '../layouts';
import { AtmScreen } from './Atm/index';

export const Atm = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window width={500} height={500} theme="light">
      <AtmScreen data={data} act={act} />
    </Window>
  );
};
