import { useBackend } from '../backend';
import { Window } from '../layouts';
import { WinXP } from './WindowsXP/index';

export const WindowsXP = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window width={1200} height={678} theme="light">
      <WinXP data={data} act={act} />
    </Window>
  );
};
