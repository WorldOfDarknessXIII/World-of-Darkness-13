import { useBackend, useSharedState } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  Section,
  Tabs,
} from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';
import { CargoCatalog } from './Cargo';

export const CargoExpress = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab, setTab] = useSharedState(context, 'tab', 'catalog');

  const orderQueue = data.order_queue ? JSON.parse(data.order_queue) : [];

  return (
    <Window width={600} height={700} resizable>
      <Window.Content scrollable>
        <InterfaceLockNoticeBox accessText="a QM-level ID card" />
        {!data.locked && (
          <CargoExpressContent
            tab={tab}
            setTab={setTab}
            orderQueue={orderQueue}
            supplies={Array.isArray(data.supplies) ? data.supplies : []}
            points={data.points || 0}
            totalOrderCost={data.total_order_cost || 0}
            usingBeacon={data.usingBeacon || false}
            hasBeacon={data.hasBeacon || false}
            beaconzone={data.beaconzone || ''}
            beaconName={data.beaconName || ''}
            message={data.message || ''}
            act={act}
          />
        )}
      </Window.Content>
    </Window>
  );
};

const CargoExpressContent = ({
  tab,
  setTab,
  orderQueue = [],
  supplies,
  points,
  totalOrderCost,
  usingBeacon,
  hasBeacon,
  beaconzone,
  beaconName,
  message,
  act,
}) => {
  return (
    <Box>
      <Section fitted>
        <Tabs>
          <Tabs.Tab
            icon="list"
            selected={tab === 'catalog'}
            onClick={() => setTab('catalog')}
          >
            Catalog
          </Tabs.Tab>
          <Tabs.Tab
            icon="shopping-cart"
            selected={tab === 'cart'}
            onClick={() => setTab('cart')}
          >
            Checkout ({orderQueue.length})
          </Tabs.Tab>
        </Tabs>
      </Section>

      {tab === 'catalog' && (
        <>
          <Section title="Cash">
            <LabeledList>
              <LabeledList.Item label="Cash">
                <AnimatedNumber value={points} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <CargoCatalog
            express
            onAddToQueue={(id) => act('add_to_queue', { id })}
            onRemoveFromQueue={(id) => act('remove_from_queue', { id })}
          />
        </>
      )}
      {tab === 'cart' && (
        <Section
          title="Order Queue"
          buttons={
            <>
              <Button
                content="Reset Queue"
                onClick={() => act('reset_queue')}
              />
              <Button
                content="Finalize Order"
                onClick={() => act('finalize_order')}
                disabled={!orderQueue.length}
              />
            </>
          }
        >
          <Section title="Cash">
            <LabeledList>
              <LabeledList.Item label="Cash:">
                <AnimatedNumber value={points} />
              </LabeledList.Item>
              <LabeledList.Item label="Total Order Cost">
                <AnimatedNumber value={totalOrderCost} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
          {orderQueue.length > 0 ? (
            orderQueue.map((pack, index) => <Box key={index}>{pack}</Box>)
          ) : (
            <Box italic>No items in the queue.</Box>
          )}
        </Section>
      )}
    </Box>
  );
};
