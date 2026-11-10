#include <mpi.h>
#include <stdio.h>
int main(int argc, char **argv) {
  int rank, size, message = 0, total = 0;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  if (rank == 0) message = 10;
  MPI_Bcast(&message, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Reduce(&message, &total, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
  printf("Rank %d of %d received %d\n", rank, size, message);
  if (rank == 0) printf("MPI sum: %d\n", total);
  MPI_Finalize();
  return size != 4 || message != 10 || (rank == 0 && total != 40);
}
