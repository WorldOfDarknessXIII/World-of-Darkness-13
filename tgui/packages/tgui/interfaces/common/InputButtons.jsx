import { useBackend } from "../../backend";
import { Box, Button, Stack } from "tgui-core/components";

export const InputButtons = (props) => {
  const { act, data } = useBackend();
  const { large_buttons = false, swapped_buttons = true } = data.preferences;
  const { input, inputIsValid } = props;

  const submitButton = (
    <Button
      color="good"
      disabled={inputIsValid && !inputIsValid.isValid}
      fluid={!!large_buttons}
      height={!!large_buttons && 2}
      onClick={() => act("submit", { entry: input })}
      pt={large_buttons ? 0.33 : 0}
      textAlign="center"
      tooltip={(!!large_buttons && inputIsValid?.error) || null}
      width={!large_buttons && 6}
    >
      {large_buttons ? "SUBMIT" : "Submit"}
    </Button>
  );
  const cancelButton = (
    <Button
      color="bad"
      fluid={!!large_buttons}
      height={!!large_buttons && 2}
      onClick={() => act("cancel")}
      pt={large_buttons ? 0.33 : 0}
      textAlign="center"
      width={!large_buttons && 6}
    >
      {large_buttons ? "CANCEL" : "Cancel"}
    </Button>
  );
  const leftButton = !swapped_buttons ? cancelButton : submitButton;
  const rightButton = !swapped_buttons ? submitButton : cancelButton;

  return (
    <Stack>
      {large_buttons ? (
        <Stack.Item grow>{leftButton}</Stack.Item>
      ) : (
        <Stack.Item>{leftButton}</Stack.Item>
      )}
      {!large_buttons && (
        <Stack.Item grow>
          {inputIsValid && !inputIsValid.isValid && inputIsValid.error && (
            <Box color="average" nowrap textAlign="center">
              {inputIsValid.error}
            </Box>
          )}
        </Stack.Item>
      )}
      {large_buttons ? (
        <Stack.Item grow>{rightButton}</Stack.Item>
      ) : (
        <Stack.Item>{rightButton}</Stack.Item>
      )}
    </Stack>
  );
};
