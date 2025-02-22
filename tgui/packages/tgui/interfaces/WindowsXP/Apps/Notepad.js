import { useLocalState } from "../../../backend";

export const Notepad = (props, context) => {
  const { app, act } = props;
  const [text, setText] = useLocalState(context, "notepad_text", app.text);
  return (
    <div className="notepad">
      <section className="np__toolbar">
        <div className="np__textbox" onClick={() => act("set_notepad_text", { ref: app.reference, text: text })}>
          <span className="np__first_letter">S</span>
          ave
        </div>
      </section>
      <textarea
        className="textarea"
        wordWrap={app.wordWrap}
        value={text}
        onInput={e => setText(e.target.value)}
        spellCheck={false}
      />
    </div>
  );
};
