import { Window } from './Window';

export const Windows = (props, context) => {
  const { apps, current_app, act } = props;
  return (
    <>
      {apps.map((app) => {
        return (
          app.launched === 1 &&
          app.reference !== current_app && <Window app={app} act={act} />
        );
      })}
      {apps.map((app) => {
        return (
          app.launched === 1 &&
          app.reference === current_app && (
            <Window app={app} act={act} is_Focus />
          )
        );
      })}
    </>
  );
};
