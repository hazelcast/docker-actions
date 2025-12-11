# test-image-size

A GitHub Action that validates image isn't excessively large / wasting space using [`dive`](https://github.com/wagoodman/dive).

Docker images are built of overlaid [layers](https://docs.docker.com/get-started/docker-concepts/building-images/understanding-image-layers), building on top of one-another. When downloading an image, each layer is downloaded.

If one layer contains a file that is subsequently removed or modified in a subsequent layer, this intermediate state will still be present in the layer to be downloaded, bloating the overall image. An example of this occurred in <https://github.com/hazelcast/hazelcast-docker/pull/1137>.

This action asserts that the amount of wasted space in an image is below a % threshold.
