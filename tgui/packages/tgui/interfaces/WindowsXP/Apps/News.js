import { useLocalState } from '../../../backend';
import { Button, Input } from '../../../components';

export const News = (props, context) => {
  const { app, act } = props;
  const [message, setMessage] = useLocalState(context, 'news_message', '');
  return (
    <div className="news__screen">
      <div className="news__text">{app.text}</div>
      {app.can_send === 1 && (
        <div className="news__actions">
          <Input
            value={message}
            onChange={(e, value) => setMessage(value)}
            placeholder="Input new text..."
          />
          <Button
            icon="paper-plane"
            onClick={() => {
              act('news_send_message', { message: message });
              setMessage('');
            }}
          />
        </div>
      )}
    </div>
  );
};
