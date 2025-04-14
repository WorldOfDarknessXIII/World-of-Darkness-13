import { Window } from "../layouts";
import { WinXP } from "./WindowsXP/index";
import { useBackend } from "../backend";

export const WindowsXP = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={1200} height={678} theme="light">
      <WinXP data={data} act={act} />
    </Window>
  );
};
